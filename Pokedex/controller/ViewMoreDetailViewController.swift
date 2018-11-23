//
//  ViewMoreDetailViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 22/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import AVFoundation


class ViewMoreDetailViewController: UIViewController {

    var player: AVPlayer?
    
    @IBOutlet weak var containerView: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 20
        
        
    }
    
    

    @IBAction func dismissDetailViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
