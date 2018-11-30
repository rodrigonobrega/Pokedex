//
//  PokedexTabBarViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 08/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit

class PokedexTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
    }
    

    fileprivate func setupViewControllers() {
        for viewController in viewControllers! {
            if let navigationViewController = viewController as? UINavigationController {
                if let tableViewController = navigationViewController.viewControllers.first as? PokedexTableViewController {
                    if tableViewController.dataController == nil {
                        tableViewController.dataController = dataController
                    }
                } else if let collectionViewController = navigationViewController.viewControllers.first as? PokedexCollectionViewController {
                    if collectionViewController.dataController == nil {
                        collectionViewController.dataController = dataController
                    }
                }
            }
        }
    }
}
