//
//  MainCollectionViewController.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 6.05.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private struct Constraits {
        static let startGameSegueIdentifier = "startGameSegueIdentifier"
        static let localThemesPath = Bundle.main.path(forResource: "theme", ofType: "json")
        static let titleText = "Dashboard"
        static let cellSpacing = CGFloat(25)
        static let cellHeight = CGFloat(150)
        static let cells = [
            ("Mode","gameModeCell"),
            ("Level", "gameLevelCell"),
            ("Theme","gameThemeCell"),
            ("Profile", "profileCell"),
            ("Statistics", "gameStatisticsCell")
        ]
    }
    
    private var configuration: GameConfiguration?
    
    
    // MARK: Theme
    private var themePreferenceIndex = 0 {
        didSet {
            // change cell background
            if themePreferenceIndex >= 0 {
                print("Theme: \(themes![themePreferenceIndex].name)")
            }
        }
    }
    
    private var themes: [GameTheme]?
    
    private func fetchLocalThemes() -> [GameTheme]? {
        guard let themes = themes else {
            var loadedThemes: [GameTheme]?
            guard let path = Constraits.localThemesPath else { return nil }
            do {
                let themesJsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                loadedThemes = try JSONDecoder().decode([GameTheme].self, from: themesJsonData)
            } catch let err {
                // ERROR; local themes could not be fetched.
                print("\(err)")
            }
            return loadedThemes
        }
        return themes
    }
    
    private func changeTheme() {
        if let themes = themes {
            if themePreferenceIndex >= (themes.count - 1)  {
                themePreferenceIndex = 0
            } else {
                themePreferenceIndex += 1
            }
        } else {
            themePreferenceIndex = -1
        }
    }
    
    // MARK: Level
    private var level = GameLevel.medium {
        didSet {
             print("\(level)")
        }
    }
    
    private func changeLevel() {
        level = GameLevel(rawValue: level.rawValue + 1) ?? .easy
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constraits.titleText
        themes = fetchLocalThemes()
        configuration = GameConfiguration(theme: themes![themePreferenceIndex], level: level)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constraits.startGameSegueIdentifier:
                if let gvc = segue.destination as? GameViewController, let config = configuration {
                    gvc.configuration = config
                }
            default:
                break
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constraits.cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DashboardCollectionViewCell
        
        cell.model = Constraits.cells[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DashboardCollectionViewCell
        switch cell.model.title {
        case "Theme":
            changeTheme()
        case "Level":
            changeLevel()
        default:
            break
        }
    }


    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2 - Constraits.cellSpacing*2, height: Constraits.cellHeight)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constraits.cellSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constraits.cellSpacing
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
