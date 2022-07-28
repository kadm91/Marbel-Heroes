//
//  CollectionViewCell.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/22/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
