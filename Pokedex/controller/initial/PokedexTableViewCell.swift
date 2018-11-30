//
//  PokedexTableViewCell.swift
//  Pokedex
//
//  Created by Rodrigo on 09/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageFavorite: UIButton!
    @IBOutlet weak var imageViewPokemon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    private let favorite = "favorite"
    private let notFavorite = "not_favorite"
    private let scaleFavoriteAnimation = "scaleFavoriteAnimation"
    
    var pokemon:Pokemon! {
        didSet {
            self.imageViewPokemon.image = UIImage()
            self.labelName.text = pokemon.name
            if let imageData = pokemon.front_default {
                self.activityIndicator.stopAnimating()
                self.imageViewPokemon.image = UIImage(data: imageData)
                self.isUserInteractionEnabled = true
            } else {
                self.isUserInteractionEnabled = false
                self.activityIndicator.startAnimating()
                pokemon.downloadImagePerfil()
            }
            if (pokemon.favorite) {
                self.imageFavorite.setImage(UIImage(named: favorite), for: .normal)
            } else {
                self.imageFavorite.setImage(UIImage(named: notFavorite), for: .normal)
            }
        }
    }

    @IBAction func updateFavorite(_ sender: Any) {
        self.superview?.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            AudioServicesPlayAlertSound(SystemSoundID(1519))
        }
        
        self.imageFavorite.layer.removeAnimation(forKey: scaleFavoriteAnimation)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.fromValue = NSNumber(value: 1)
        animation.toValue = NSNumber(value: 1.6)
        animation.repeatCount = 1
        animation.autoreverses = true
      
        self.imageFavorite.layer.add(animation, forKey: scaleFavoriteAnimation)
        
        if (self.pokemon.favorite) {
            updateFavoriteImage(SoundUtil.SoundName.favorite)
        } else {
            updateFavoriteImage(SoundUtil.SoundName.notFavorite)
        }
        
    }
    
    func updateFavoriteImage(_ name:SoundUtil.SoundName!) {
        self.imageFavorite.setImage(UIImage(named: name.rawValue), for: .normal)
        SoundUtil.playSound(name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pokemon.favorite = !self.pokemon.favorite
            self.superview?.isUserInteractionEnabled = true
        }
    }

}
