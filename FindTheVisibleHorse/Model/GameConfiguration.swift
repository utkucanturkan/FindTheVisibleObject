//
//  GameBrain.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 7.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

enum GameLevel: Int {
    case easy = 0, medium, hard
}

struct GameConfiguration {
    
    fileprivate struct Constraints {
        static let minDimensions = (25.0, 25.0)
        static let defaultDimensions = (50.0, 50.0)
        static let maxDimensions = (75.0, 75.0)
        
        
        static let distanceSoundPath = Bundle.main.path(forResource: "beep", ofType: "wav")
        static let successSoundPath = Bundle.main.path(forResource: "horse-whinny", ofType: "wav")
    }
    
    var theme: GameTheme
    var level: GameLevel   
    
    var distanceSoundPath: URL
    var successSoundPath: URL
    var targetViewDimensions: (Double, Double) {
        switch level {
        case .easy:
            return Constraints.maxDimensions
        case .medium:
            return Constraints.defaultDimensions
        case .hard:
            return Constraints.minDimensions
        }
    }
    var halfOfMinDimension: Double {
        return min(targetViewDimensions.0, targetViewDimensions.1)/2
    }
    
    init(theme: GameTheme, level: GameLevel) {
        self.theme = theme
        self.level = level
        
        distanceSoundPath = URL(fileURLWithPath: Constraints.distanceSoundPath!)
        successSoundPath = URL(fileURLWithPath: Constraints.successSoundPath!)
    }
}
