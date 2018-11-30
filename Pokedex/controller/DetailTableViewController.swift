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
    @IBOutlet weak var imageFavorite: UIButton!

    var player: AVPlayer?
    var dataController:DataController!
    var pokemon:Pokemon!
    var soundAnimated = false;
    
    private let favorite = "favorite"
    private let notFavorite = "favorite"
    private let scaleImage = "scaleImage"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    fileprivate func setupLayout() {
        self.title = pokemon.name
        self.imagePokemonView.image = UIImage(data: pokemon.front_default!)
        self.imagePokemonView.layer.cornerRadius = self.imagePokemonView.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (pokemon.favorite) {
            self.imageFavorite.setImage(UIImage(named: favorite), for: .normal)
        } else {
            self.imageFavorite.setImage(UIImage(named: notFavorite), for: .normal)
        }
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
    
    @IBAction func updateFavorite(_ sender: Any) {
        self.tableView?.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            AudioServicesPlayAlertSound(SystemSoundID(1519))
        }
        
        self.imageFavorite.layer.removeAnimation(forKey: scaleImage)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.fromValue = NSNumber(value: 1)
        animation.toValue = NSNumber(value: 1.6)
        animation.repeatCount = 1
        animation.autoreverses = true
        
        self.imageFavorite.layer.add(animation, forKey: scaleImage)
        
        
        if (!self.pokemon.favorite) {
            updateFavoriteImage(SoundUtil.SoundName.favorite)
        } else {
            updateFavoriteImage(SoundUtil.SoundName.notFavorite)
        }
        
    }
    
    func updateFavoriteImage(_ name:SoundUtil.SoundName!) {
        DispatchQueue.main.async {
            self.imageFavorite.setImage(UIImage(named: name.rawValue), for: .normal)
            SoundUtil.playSound(name)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pokemon.favorite = !self.pokemon.favorite
            self.tableView?.isUserInteractionEnabled = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? ImagesViewController {
            detailViewController.dataController = self.dataController
            detailViewController.pokemon = sender as? Pokemon
        }
    }
    
}

extension DetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (pokemon.front_default == UIImage(named: "not_found")?.pngData()) {
            showMessage("Has no images to display 🥺")
            tableView.deselectRow(at: indexPath, animated: true)
        }else {
            self.performSegue(withIdentifier: "viewImageSegue", sender: pokemon)
        }
    }
    
    func showMessage(_ message:String) {
        let alert = UIAlertController(title: "Pokedex", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



