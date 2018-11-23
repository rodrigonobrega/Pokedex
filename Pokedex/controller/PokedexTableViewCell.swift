//
//  PokedexTableViewCell.swift
//  Pokedex
//
//  Created by Rodrigo on 09/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class PokedexTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageFavorite: UIButton!
    @IBOutlet weak var imageViewPokemon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var pokemon:Pokemon! {
        didSet {
            self.imageViewPokemon.image = UIImage()
            self.labelName.text = pokemon.name
            if let imageData = pokemon.front_default {
                self.activityIndicator.stopAnimating()
                self.imageViewPokemon.image = UIImage(data: imageData)
            } else {
                self.activityIndicator.startAnimating()
                pokemon.downloadImagePerfil()
            }
            if (pokemon.favorite) {
                self.imageFavorite.setImage(UIImage(named: "favorite"), for: .normal)
            } else {
                self.imageFavorite.setImage(UIImage(named: "not_favorite"), for: .normal)
            }
        }
    }

    @IBAction func updateFavorite(_ sender: Any) {
        self.superview?.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            AudioServicesPlayAlertSound(SystemSoundID(1519))
        }
        
        self.imageFavorite.layer.removeAnimation(forKey: "scalew")
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.fromValue = NSNumber(value: 1)
        animation.toValue = NSNumber(value: 1.6)
        animation.repeatCount = 1
        animation.autoreverses = true
      
        self.imageFavorite.layer.add(animation, forKey: "scalew")
        
        
        if (self.pokemon.favorite) {
            self.imageFavorite.setImage(UIImage(named: "favorite"), for: .normal)
            PokedexTableViewCell.playSound("favorite")
        } else {
            self.imageFavorite.setImage(UIImage(named: "not_favorite"), for: .normal)
            PokedexTableViewCell.playSound("not_favorite")
        }
        

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pokemon.favorite = !self.pokemon.favorite
            self.superview?.isUserInteractionEnabled = true
        }
        
    }
    
    static var player: AVAudioPlayer?
    
    static func playSound( _ fileName: String!) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
