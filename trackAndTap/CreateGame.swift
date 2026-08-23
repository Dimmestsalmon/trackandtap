import MultipeerConnectivity
import SwiftUI

struct CreateGame: View {
    @ObservedObject var gameSession: MultipeerConnector

    var body: some View {
        VStack(spacing: 16) {
            Text("Game Lobby")
                .font(.title)

            Text("Host: \(gameSession.peerID.displayName)")

            if gameSession.connectedPeers.isEmpty {
                Text("Waiting for players to join…")
                    .foregroundStyle(.secondary)
            } else {
                Text("Players joined: \(gameSession.connectedPeers.count)")

                ForEach(gameSession.connectedPeers, id: \.self) { peer in
                    HStack {
                        Text(peer.displayName)

                        Spacer()

                        Menu {
                            ForEach(
                                gameSession.availableSeatIndices,
                                id: \.self
                            ) { seat in
                                Button("Player \(seat + 1)") {
                                    gameSession.assign(peer, to: seat)
                                }
                            }
                        } label: {
                            if let seat = gameSession.assignedSeat(for: peer) {
                                Text("Player \(seat + 1)")
                            } else {
                                Text("Assign seat")
                            }
                        }
                    }
                }
            }

            Button("Start Game") {
                gameSession.startGame()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!gameSession.canStartGame)
        }
        .padding()
        .onAppear { gameSession.startAdvertising() }
        .onDisappear { gameSession.stopAdvertising() }
    }
}
