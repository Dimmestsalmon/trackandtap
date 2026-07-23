//
//  FindGame.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/14/26.
//

import MultipeerConnectivity
import SwiftUI

struct JoinGame: View {
    @ObservedObject var gameSession: MultipeerConnector
    
    var body: some View {
        VStack {
            Text("Available Games").font(.title)
            
            ForEach(gameSession.foundPeers, id: \.self) { peer in
                Button(peer.displayName) {
                    gameSession.gameGuest.invitePeer(
                        peer,
                        to: gameSession.gameSession,
                        withContext: nil,
                        timeout: 30
                    )
                }
            }
        }
        .onAppear { gameSession.startBrowsing() }
        .onDisappear { gameSession.stopBrowsing() }
    }
}


