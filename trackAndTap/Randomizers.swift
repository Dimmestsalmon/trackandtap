//
//  Randomizers.swift
//  trackAndTap
//
//  Created by Nephi Appel on 5/14/26.
//

struct RandomName {
    private static let firstNames = ["Alice", "Bob", "Charlie", "Diana", "Elara",
                                      "Finn", "Gwen", "Hugo", "Iris", "Jasper"]
    private static let lastNames = ["Starfall", "Ironwood", "Ashborne", "Duskwalker",
                                     "Brightstone", "Thornveil", "Moonridge"]
    
    static func generate() -> String {
        "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
    }
}

