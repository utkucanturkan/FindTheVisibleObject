//
//  MainViewController.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 8.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    }
    
    private var themePreferenceIndex = 0
    
    private var gameTheme: GameTheme? {
        if let theme = loadLocalThemes() {
            return theme[themePreferenceIndex]
        }
        return nil
    }
    
    private func loadLocalThemes() -> [GameTheme]? {
        var themes: [GameTheme]?
        guard let path = Bundle.main.path(forResource: "theme", ofType: "json") else { return themes }
        do {
            let themesJsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            themes = try JSONDecoder().decode([GameTheme].self, from: themesJsonData)
        } catch let err {
            print("\(err)")
        }
        return themes
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "StartGame":
                if let gvc = segue.destination as? GameViewController {
                    gvc.theme = gameTheme
                }
            default:
                break
            }
        }
    }
}
