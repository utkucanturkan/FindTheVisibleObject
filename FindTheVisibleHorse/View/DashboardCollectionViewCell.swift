//
//  DashboardCollectionViewCell.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 6.05.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    private var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    var model: (title: String, imageName: String)? {
        didSet {
            title?.text = model?.title
            if let imageName = model?.imageName {
                image = UIImage(named: imageName)
            }
        }
    }
}
