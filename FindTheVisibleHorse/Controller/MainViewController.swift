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

        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "theme", ofType: "json") {
            do {
                let themesJsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let themes = try? JSONDecoder().decode(GameTheme.self, from: themesJsonData)
            } catch  {
                // ERROR
            }
        }
        

    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    }  
     
}
