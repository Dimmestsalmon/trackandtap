//
//  playerLife.swift
//  trackAndTap
//
//  Created by Nephi Appel on 4/24/26.
//
import Foundation
import Combine

class PlayerStatus: ObservableObject {
    @Published var totals: [Int]
    @Published var playerName: String
    
    init(playerLife: Int = 40, playerCount: Int = 4) {
        self.totals = Array(repeating: playerLife, count: playerCount)
        playerName = RandomName.generate()
    }
    
    func increaseLife(_ index: Int) {
            totals[index] += 1
        }
        
    func decreaseLife(_ index: Int) {
        totals[index] -= 1
    }

}
    
