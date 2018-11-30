//
//  ImageViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 26/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var imageViewSelected: UIImageView!
    var imageData:Data!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageViewSelected.image = UIImage(data: imageData)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
        self.imageViewSelected.addGestureRecognizer(pinch)
    }
    
    @objc func zoomImage(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1
    }

    @IBAction func dismissImageViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        
        self.present(self.showActivityController(), animated: true)
    }
    
    func showActivityController()  -> UIActivityViewController {
        let pokemonImage = self.imageViewSelected.image
        let objects:[AnyObject] = [Constants.Pokedex.messageActivityShare as AnyObject, pokemonImage!]
        let activityController = UIActivityViewController(activityItems: objects , applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                activityController.dismiss(animated: true)
            }
        }
        
        return activityController
    }
    

}
