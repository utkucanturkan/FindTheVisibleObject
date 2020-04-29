//
//  GameTheme.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 26.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct GameTheme: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name, backgroundImageName, targetImageNames, soundNames
    }
    
    enum SoundType: String, Decodable {
        case far, middle, near, success
    }
    
    private(set) var name: String
    private(set) var backgroundImageName: String
    var targetImageNames: [String]
    var soundNames: [SoundType: String]
    
    var randomTargetImageName: String {
        return targetImageNames[Int.random(in: 0..<targetImageNames.count)]
    }
}
