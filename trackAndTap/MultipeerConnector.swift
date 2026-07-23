//
//  MultipeerConnector.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/13/26.
//
#if os(iOS)
import UIKit
#endif
import MultipeerConnectivity
import Combine

class MultipeerConnector: NSObject, ObservableObject {
    
    @Published var foundPeers: [MCPeerID] = []
    let serviceType = "tracktap"
    let peerID: MCPeerID
    let gameSession: MCSession
    let gameHost: MCNearbyServiceAdvertiser
    let gameGuest: MCNearbyServiceBrowser
    var connectedPeer: MCPeerID? = nil
    
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
        gameHost.delegate = self
        gameHost.startAdvertisingPeer()
        print("Started advertising")
    }
    
    func stopAdvertising() {
        gameHost.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        gameGuest.delegate = self
        gameGuest.startBrowsingForPeers()
        print("Started browsing")
    }
    
    func stopBrowsing() {
        gameGuest.stopBrowsingForPeers()
    }
}
