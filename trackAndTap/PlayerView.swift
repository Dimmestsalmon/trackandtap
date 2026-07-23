//
//  playerView.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/1/26.
//

import Foundation
import SwiftUI

struct PlayerView: View {
    @StateObject private var playerLife = PlayerStatus()
    @StateObject private var playerName = PlayerStatus()
    
    
    var body: some View {
        Grid {
            ForEach(0..<1) {row in
                GridRow{
                    ForEach(0..<1) { column in
                        let index = row * 2 + column
                        Button(action: {playerLife.increaseLife(index)}) {
                            Text("+")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Text("\(playerLife.totals[index])")
                                .font(.title)
                                .frame(minWidth: 40)
                        Button(action: {playerLife.decreaseLife(index)}) {
                            Text("-")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
#Preview {
    PlayerView()
}
