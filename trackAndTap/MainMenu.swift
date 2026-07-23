//
//  MainMenu.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/1/26.
//

import SwiftUI

struct MainMenu: View {
    @StateObject var gameSession = MultipeerConnector()
    @StateObject private var playerStatus = PlayerStatus()
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
                    // 2. Bind the TextField to the variable using '$'
                    TextField("Enter name here...", text: $userInput)
                        .textFieldStyle(.roundedBorder) // Optional: Adds a border
                        .padding()
                    Button("set Name"){
                        playerStatus.playerName = userInput
                    }
                }
        NavigationStack {
            NavigationLink("Join Game") {
                JoinGame(gameSession: gameSession)
            }
            NavigationLink("Create Game") {
                CreateGame(gameSession: gameSession)
            }
        }
        
    }
}
#Preview {
    MainMenu()
}
