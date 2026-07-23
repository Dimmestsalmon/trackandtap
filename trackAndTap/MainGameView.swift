//
//  ContentView.swift
//  trackAndTap
//
//  Created by Nephi Appel on 4/24/26.
//

import SwiftUI

struct MainGameView: View {
    @StateObject private var playerLife = PlayerStatus()
    
    var body: some View {
        Grid {
            ForEach(0..<2) {row in
                GridRow{
                    ForEach(0..<2) { column in
                        let index = row * 2 + column
                        Button(action: {playerLife.decreaseLife(index)}) {
                            Text("-")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Text("\(playerLife.totals[index])")
                                .font(.title)
                                .frame(minWidth: 40)
                        Button(action: {playerLife.increaseLife(index)}) {
                            Text("+")
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
    MainGameView()
}
