//
//  GameBrain.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 7.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct GameBrain {
    
    fileprivate struct Constraints {
        static let minViewSize = (25.0, 25.0)
        static let maxViewSize = (75.0, 75.0)
        static let fontSize = 50.0
        static let distanceSoundPath = Bundle.main.path(forResource: "beep", ofType: "wav")
        static let successSoundPath = Bundle.main.path(forResource: "horse-whinny", ofType: "wav")
    }
    
    var theme: String
    var emoji: String
    var distanceSoundPath: URL
    var successSoundPath: URL
    var fontSize: Double
    var size: (Double, Double)
    var minViewSize: (Double, Double) {
        return Constraints.minViewSize
    }
    var maxViewSize: (Double, Double) {
        return Constraints.maxViewSize
    }
    var halfOfMinDimension: Double {
        return min(size.0, size.1)/2
    }
    
    init() {
        theme = "Horse"
        emoji = "🐴"
        size = Constraints.maxViewSize
        fontSize = Constraints.fontSize
        distanceSoundPath = URL(fileURLWithPath: Constraints.distanceSoundPath!)
        successSoundPath = URL(fileURLWithPath: Constraints.successSoundPath!)
    }    
}
