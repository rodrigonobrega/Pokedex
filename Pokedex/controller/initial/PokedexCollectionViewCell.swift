//
//  PokedexCollectionViewCell.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView! {
        didSet {
            imagePokemon.layer.cornerRadius = imagePokemon.frame.width/2;
            self.layer.cornerRadius = 20
        }
    }
    
    var pokemon:Pokemon! {
        didSet {
            self.labelName.text = pokemon.name
            self.labelName.layer.cornerRadius = 5
            self.labelName.layer.masksToBounds = true
            self.labelName.layer.borderColor = UIColor.gray.cgColor
            self.labelName.layer.borderWidth = 0.5
            
            if let imageData = pokemon.front_default {
                self.imagePokemon.image = UIImage(data: imageData)
                self.imagePokemon.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.backgroundImageView.image = UIImage(data: imageData)
                self.backgroundImageView.transform = CGAffineTransform(scaleX: 4, y: 4)
                
            } else {
                pokemon.downloadImagePerfil()
            }
        }
    }
    
}
