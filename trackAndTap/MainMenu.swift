import SwiftUI

struct MainMenu: View {
    @StateObject private var gameSession = MultipeerConnector()
    @State private var userInput: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                NavigationLink("Join Game") {
                    JoinGame(gameSession: gameSession)
                }

                NavigationLink("Create Game") {
                    CreateGame(gameSession: gameSession)
                }
            }
            .navigationDestination(isPresented: $gameSession.gameHasStarted) {
                if gameSession.role == .host {
                    MainGameView(gameSession: gameSession)
                } else if let playerIndex = gameSession.assignedPlayerIndex {
                    PlayerView(
                        gameSession: gameSession,
                        playerIndex: playerIndex
                    )
                } else {
                    ProgressView("Waiting for player assignment…")
                }
            }
        }
    }
}
#Preview {
    MainMenu()
}
