//
//  createGame.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/13/26.
//
import MultipeerConnectivity
import SwiftUI

struct CreateGame: View {
    @ObservedObject var gameSession: MultipeerConnector
    
    var body: some View {
        Grid{
            Button(gameSession.peerID.displayName){
                
            }
        }
        .onAppear { gameSession.startAdvertising() }
        .onDisappear { gameSession.stopAdvertising() }
    }
        
}

