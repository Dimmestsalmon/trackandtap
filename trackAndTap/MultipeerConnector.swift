#if os(iOS)
import UIKit
#endif
import MultipeerConnectivity
import Combine

class MultipeerConnector: NSObject, ObservableObject {
    
    @Published var foundPeers: [MCPeerID] = []
    @Published private(set) var connectedPeers: [MCPeerID] = []
    @Published private(set) var connectionStatus = "Not connected"
    @Published var gameHasStarted = false
    @Published private(set) var gameState = GameState()
    @Published private(set) var role: SessionRole = .none
    @Published private(set) var assignedPlayerIndices: [MCPeerID: Int] = [:]
    @Published private(set) var assignedPlayerIndex: Int?
    private var processedRequestIDs = Set<UUID>()
    let serviceType = "tracktap"
    let peerID: MCPeerID
    let gameSession: MCSession
    let gameHost: MCNearbyServiceAdvertiser
    let gameGuest: MCNearbyServiceBrowser
    
    enum SessionRole: Equatable {
        case none
        case host
        case guest
    }

    struct LifeChangeRequest: Codable {
        let requestID: UUID
        let playerIndex: Int
        let delta: Int
        let basedOnRevision: Int
    }

    enum GameMessage: Codable {
        case state(GameState)
        case lifeChange(LifeChangeRequest)
        case playerAssignment(Int)
        case startGame
    }
    
    
    override init() {
        #if os(iOS)
        peerID = MCPeerID(displayName: UIDevice.current.name)
        #else
        peerID = MCPeerID(displayName: Host.current().localizedName ?? "Player")
        #endif
        gameSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        gameHost = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        gameGuest = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        gameSession.delegate = self
    }
    
    func startAdvertising() {
        role = .host
        gameHost.delegate = self
        gameHost.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        gameHost.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        role = .guest
        gameGuest.delegate = self
        gameGuest.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        gameGuest.stopBrowsingForPeers()
    }
    
    func updateConnectionState(_ state: MCSessionState, for peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.connectedPeers = self.gameSession.connectedPeers

            switch state {
            case .connecting:
                self.connectionStatus = "Connecting to \(peerID.displayName)…"

            case .connected:
                self.connectionStatus = "Connected to \(peerID.displayName)"

            case .notConnected:
                self.connectionStatus = "\(peerID.displayName) disconnected"
                print("\(peerID.displayName) disconnected")

            @unknown default:
                self.connectionStatus = "Unknown connection state"
            }
        }
    }

    func updateConnectedPeers() {
        connectedPeers = gameSession.connectedPeers
    }
    
    func requestLifeChange(index: Int, delta: Int) {
        guard delta != 0 else { return }

        if role == .host {
            applyApprovedLifeChange(index: index, delta: delta)
            return
        }

        let request = LifeChangeRequest(
            requestID: UUID(),
            playerIndex: index,
            delta: delta,
            basedOnRevision: gameState.revision
        )
        send(.lifeChange(request))
    }
    
    private func applyApprovedLifeChange(index: Int, delta: Int) {
        guard gameState.totals.indices.contains(index) else { return }

        gameState.totals[index] += delta
        gameState.revision += 1
        broadcast(.state(gameState))
    }
    
    func send(_ message: GameMessage, to peers: [MCPeerID]? = nil) {
        guard let data = try? JSONEncoder().encode(message) else { return }

        let recipients = peers ?? gameSession.connectedPeers
        guard !recipients.isEmpty else { return }

        do {
            try gameSession.send(data, toPeers: recipients, with: .reliable)
        } catch {
            print("Could not send game message: \(error)")
        }
    }

    func broadcast(_ message: GameMessage) {
        send(message)
    }
    
    func handle(_ message: GameMessage, from peer: MCPeerID) {
        switch message {
        case .state(let newState):
            guard role == .guest else { return }
            gameState = newState

        case .lifeChange(let request):
            guard role == .host else { return }
            guard gameSession.connectedPeers.contains(peer) else { return }
            guard gameState.totals.indices.contains(request.playerIndex) else { return }
            guard (-100...100).contains(request.delta), request.delta != 0 else { return }
            guard processedRequestIDs.insert(request.requestID).inserted else { return }
            guard assignedPlayerIndices[peer] == request.playerIndex else { return }

            applyApprovedLifeChange(
                index: request.playerIndex,
                delta: request.delta
            )
            
        case .startGame:
            guard role == .guest else { return }
            gameHasStarted = true
            
        case .playerAssignment(let playerIndex):
            guard role == .guest else { return }
            guard gameState.totals.indices.contains(playerIndex) else { return }

            assignedPlayerIndex = playerIndex
        }
        
        
    }
    
    func startGame() {
        guard role == .host, !gameHasStarted else { return }

        gameHasStarted = true
        send(.startGame)
    }
    
    func assignPlayer(to peer: MCPeerID) {
        guard role == .host else { return }

        let playerIndex: Int

        if let existingIndex = assignedPlayerIndices[peer] {
            playerIndex = existingIndex
        } else {
            let assignedIndices = Set(assignedPlayerIndices.values)

            guard let availableIndex = gameState.totals.indices.first(
                where: { !assignedIndices.contains($0) }
            ) else {
                print("No player slots remain available.")
                return
            }

            assignedPlayerIndices[peer] = availableIndex
            playerIndex = availableIndex
        }

        send(.playerAssignment(playerIndex), to: [peer])
    }

    func removePlayerAssignment(for peer: MCPeerID) {
        assignedPlayerIndices.removeValue(forKey: peer)
    }
    
    func assign(_ peer: MCPeerID, to playerIndex: Int) {
        guard role == .host else { return }
        guard gameSession.connectedPeers.contains(peer) else { return }
        guard gameState.totals.indices.contains(playerIndex) else { return }

        // A seat can belong to only one guest.
        guard !assignedPlayerIndices.contains(where: {
            $0.key != peer && $0.value == playerIndex
        }) else { return }

        assignedPlayerIndices[peer] = playerIndex
        send(.playerAssignment(playerIndex), to: [peer])
    }
    
    func assignedSeat(for peer: MCPeerID) -> Int? {
        assignedPlayerIndices[peer]
    }

    var availableSeatIndices: [Int] {
        gameState.totals.indices.filter { seat in
            !assignedPlayerIndices.values.contains(seat)
        }
    }

    var canStartGame: Bool {
        !connectedPeers.isEmpty &&
        connectedPeers.allSatisfy { assignedPlayerIndices[$0] != nil }
    }
}
