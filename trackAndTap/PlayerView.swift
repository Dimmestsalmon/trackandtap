import SwiftUI

struct PlayerView: View {
    @ObservedObject var gameSession: MultipeerConnector
    let playerIndex: Int

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Health")
                .font(.title)

            if gameSession.gameState.totals.indices.contains(playerIndex) {
                Text("\(gameSession.gameState.totals[playerIndex])")
                    .font(.system(size: 72, weight: .bold))

                HStack(spacing: 24) {
                    Button("-") {
                        gameSession.requestLifeChange(
                            index: playerIndex,
                            delta: -1
                        )
                    }

                    Button("+") {
                        gameSession.requestLifeChange(
                            index: playerIndex,
                            delta: 1
                        )
                    }
                }
                .font(.largeTitle)
                .buttonStyle(.borderedProminent)
            } else {
                ProgressView("Waiting for player assignment…")
            }
        }
        .padding()
    }
}
