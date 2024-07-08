//
//  Model.swift
//  MidtermSummer24
//
//  Created by Satiar Rad on 2024-07-03.
//

import Foundation
struct Donut : CustomStringConvertible {
    var description: String {
        return "\(shortName) $\(price)"
    }
    
   
    
    var title: String
    var price: Double
    var shortName: String
    var imageName: String
    var availabilityCount: Int = Int.random(in: 1...5)
    
}

class Store{
    // MARK: sample data
    // Example usage:
    lazy var chocolateGlazeDonut = Donut(
        title: "Delicious Strawberry Glaze Donut with Sprinkles",
        price: 1.99,
        shortName: "Glaze",
        imageName: "strawberryJam.png"
    )
    
    lazy var strawberryFrostingDonut = Donut(
        title: "Sweet Strawberry Frosting Donut",
        price: 2.49,
        shortName: "Strawberry",
        imageName: "strawberry_frosting_donut.png"
    )
    
    lazy var powderedSugarDonut = Donut(
        title: "Classic Powdered Sugar Donut",
        price: 1.79,
        shortName: "Powdered",
        imageName: "powdered_sugar_donut.png"
    )
    
    lazy var jellyFilledDonut = Donut(
        title: "Tasty Jelly-Filled Donut",
        price: 2.99,
        shortName: "Jelly",
        imageName: "jelly_filled_donut.png"
    )
    
    lazy var cinnamonSugarDonut = Donut(
        title: "Cinnamon Sugar Donut",
        price: 2.19,
        shortName: "Cinnamon",
        imageName: "cinnamon_sugar_donut.png"
    )
    
    lazy var vanillaFrostingDonut = Donut(
        title: "Vanilla Frosting Donut",
        price: 2.29,
        shortName: "Vanilla",
        imageName: "vanilla_frosting_donut.png"
    )
    
    lazy var mapleGlazeDonut = Donut(
        title: "Maple Glaze Donut",
        price: 2.39,
        shortName: "Maple",
        imageName: "maple_glaze_donut.png"
    )
    
   
    
    // Array of donuts
    lazy var donuts = [
        chocolateGlazeDonut,
        strawberryFrostingDonut,
        powderedSugarDonut,
        jellyFilledDonut,
        cinnamonSugarDonut,
        vanillaFrostingDonut,
        mapleGlazeDonut,
     
    ]
}
