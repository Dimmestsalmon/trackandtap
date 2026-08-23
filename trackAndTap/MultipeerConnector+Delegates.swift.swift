import MultipeerConnectivity

// MCSessionDelegate
extension MultipeerConnector: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        updateConnectionState(state, for: peerID)

        if state == .connected, role == .host {
            DispatchQueue.main.async {
                self.send(.state(self.gameState), to: [peerID])
                self.assignPlayer(to: peerID)

                if self.gameHasStarted {
                    self.send(.startGame, to: [peerID])
                }
            }
        }
        
        if state == .notConnected, role == .host {
            DispatchQueue.main.async {
                self.removePlayerAssignment(for: peerID)
            }
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(GameMessage.self, from: data) else {
            return
        }

        DispatchQueue.main.async {
            self.handle(message, from: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
    
}

// MCNearbyServiceAdvertiserDelegate
extension MultipeerConnector: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, gameSession)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Advertising failed: \(error)")
    }
    
}

// MCNearbyServiceBrowserDelegate
extension MultipeerConnector: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        DispatchQueue.main.async {
            if !self.foundPeers.contains(peerID) {
                self.foundPeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.foundPeers.removeAll { $0 == peerID }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Browsing failed: \(error)")
    }
}


