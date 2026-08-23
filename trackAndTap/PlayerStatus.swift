import Foundation

struct GameState: Codable, Equatable {
    var totals: [Int]
    var revision: Int

    init(playerLife: Int = 40, playerCount: Int = 4) {
        totals = Array(repeating: playerLife, count: playerCount)
        revision = 0
    }
}
