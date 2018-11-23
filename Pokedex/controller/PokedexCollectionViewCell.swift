//
//  PokedexCollectionViewCell.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView! {
        didSet {
            imagePokemon.layer.cornerRadius = imagePokemon.frame.height/2;
            self.layer.cornerRadius = 20
        }
    }
    
    
    
}
