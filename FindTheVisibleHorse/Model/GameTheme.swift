//
//  GameTheme.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 26.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import Foundation

struct GameTheme {
    
    enum Sound {
        case far(String)
        case middle(String)
        case near(String)
        case success(String)
    }
    
    private(set) var name: String
    private(set) var backgroundImageName: String = "spaceBackground"
    var targetImageNames = [String]()
    var sounds = [Sound]()
    var randomTargetImageName: String {
        //return targetImageNames[Int.random(in: 0..<targetImageNames.count)]
        return "rocket"
    }
    
    init(name: String) {
        self.name = name
        sounds.append(contentsOf: [.far("farSound"), .middle("middleSound"), .near("nearSound"), .success("successSound")])
    }
}
