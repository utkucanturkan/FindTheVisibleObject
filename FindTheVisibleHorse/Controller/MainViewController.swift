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
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    }  
     
}
