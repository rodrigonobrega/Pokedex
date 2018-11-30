//
//  DetailTableViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 30/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import AVFoundation


class DetailTableViewController: UITableViewController {

    

    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var imagePokemonView: UIImageView!
    
    var player: AVPlayer?
    var dataController:DataController!
    var pokemon:Pokemon!
    var soundAnimated = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pokemon.name
        self.imagePokemonView.image = UIImage(data: pokemon.front_default!)
        self.imagePokemonView.layer.cornerRadius = self.imagePokemonView.frame.height/2
        pokemon.favorite = true
    }

    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!soundAnimated) {
            UIApplication.shared.beginIgnoringInteractionEvents()
            soundAnimated = true
            self.incrementLabel(self.labelHeight, to: Int(pokemon!.height)) {
                self.incrementLabel(self.labelWeight, to: Int(self.pokemon!.weight), completion: {
                    self.incrementLabel(self.labelExperience, to: Int(self.pokemon!.base_experience), completion: {
                        DispatchQueue.main.async {
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    })
                })
            }
        }
    }
    
    func incrementLabel(_ label:UILabel, to endValue: Int, completion: (() -> Void)? = nil) {
        if endValue == 0 {
            return
        }
        let duration: Double = 0.5
        SoundUtil.playSound(SoundUtil.SoundName.tick)
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    label.text = "\(i)"
                }
            }
            DispatchQueue.main.async {
                self.animationLabel(label)
            }
            SoundUtil.playSound(SoundUtil.SoundName.finished)
            usleep(300000)
            completion?()
            
        }
    }
    
    func animationLabel(_ label:UILabel) {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 2.2
        scale.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scale.autoreverses = true
        scale.duration = 0.15
        label.layer.add(scale, forKey: "scaleAnimation")
    }
    
    @IBAction func viewMoreImages(_ sender: Any) {
        self.performSegue(withIdentifier: "viewImageSegue", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? ImagesViewController {
            detailViewController.dataController = self.dataController
            detailViewController.pokemon = sender as? Pokemon
        }
    }
    
    
    

}
