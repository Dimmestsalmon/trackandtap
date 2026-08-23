import SwiftUI

struct MainGameView: View {
    @ObservedObject var gameSession: MultipeerConnector

    var body: some View {
        Grid {
            ForEach(0..<2) { row in
                GridRow {
                    ForEach(0..<2) { column in
                        let index = row * 2 + column

                        Button("-") {
                            gameSession.requestLifeChange(index: index, delta: -1)
                        }

                        Text("\(gameSession.gameState.totals[index])")
                            .font(.title)

                        Button("+") {
                            gameSession.requestLifeChange(index: index, delta: 1)
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    MainGameView(gameSession: MultipeerConnector())
}
