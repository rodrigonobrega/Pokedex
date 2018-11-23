//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    var arrayImages:[Data] = []
    var dataController:DataController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    lazy var fetchedResultsController: NSFetchedResultsController<Pokemon> = {
        
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", self.pokemon.identifier!)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
  
    
    var pokemon:Pokemon! {
        didSet {
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError(error.localizedDescription)
            }
            
            self.title = pokemon.name
            self.addImageElementToArray()
            //self.addImages()
            pokemon.downloadDetailImages()
            //updateImages()
        }
    }

    
    @IBAction func dismissDetailViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewMoreDetailSegue", sender: self)
    }
    fileprivate func updateImages() {
        if arrayImages.count > 0 {
            print("image")
            let image = UIImage(data: arrayImages.first!)
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.frame
            self.view.addSubview(imageView)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal  // .horizontal
        }
        self.backButton.title = ">＞﹥"
        // Create the info button
//        let infoButton = UIButton(type: .infoLight)
        //infoButton.titleLabel?.text = ">＞﹥"
        
        // You will need to configure the target action for the button itself, not the bar button itemr
        //backButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        // Create a bar button item using the info button as its custom view
       // let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // Use it as required
        navigationItem.rightBarButtonItem = backButton
//        let gradient = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.startPoint = CGPoint(x:0.0, y:0.5)
//        gradient.endPoint = CGPoint(x:1.0, y:0.5)
//        gradient.colors = [UIColor.white.cgColor, UIColor.red.cgColor]
//        gradient.locations =  [-0.5, 1.5]
//        
//        let animation = CABasicAnimation(keyPath: "colors")
//        animation.fromValue = [UIColor.white.cgColor, UIColor.red.cgColor]
//        animation.toValue = [UIColor.white.cgColor, UIColor.gray.cgColor]
//        animation.duration = 2
//        animation.autoreverses = true
//        animation.repeatCount = Float.infinity
//        
//        gradient.add(animation, forKey: nil)
//        self.view.layer.addSublayer(gradient)
    }
    
    @objc func showDetail() {
        self.performSegue(withIdentifier: "ViewMoreDetailSegue", sender: self)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension DetailViewController {
    
//    fileprivate func addImages() {
////        self.addImageElementToArray(pokemon.back_default)
////        self.addImageElementToArray(pokemon.back_female)
////        self.addImageElementToArray(pokemon.back_shiny)
////        self.addImageElementToArray(pokemon.back_shiny_female)
////        self.addImageElementToArray(pokemon.front_female)
////        self.addImageElementToArray(pokemon.front_shiny)
////        self.addImageElementToArray(pokemon.front_shiny_female)
//        self.addImageElementToArray()
//    }
    
   
    
    private func addImageElementToArray() {
        if pokemon.back_default != nil && !arrayImages.contains(pokemon.back_default!) {
            arrayImages.append(pokemon.back_default!)
        }
        if pokemon.front_default != nil && !arrayImages.contains(pokemon.front_default!) {
            arrayImages.append(pokemon.front_default!)
        }
        if pokemon.back_female != nil && !arrayImages.contains(pokemon.back_female!) {
            arrayImages.append(pokemon.back_female!)
        }
        if pokemon.back_shiny != nil && !arrayImages.contains(pokemon.back_shiny!) {
            arrayImages.append(pokemon.back_shiny!)
        }
        if pokemon.back_shiny_female != nil && !arrayImages.contains(pokemon.back_shiny_female!) {
            arrayImages.append(pokemon.back_shiny_female!)
        }
        if pokemon.front_female != nil && !arrayImages.contains(pokemon.front_female!) {
            arrayImages.append(pokemon.front_female!)
        }
        if pokemon.front_shiny != nil && !arrayImages.contains(pokemon.front_shiny!) {
            arrayImages.append(pokemon.front_shiny!)
        }
        if pokemon.front_shiny_female != nil && !arrayImages.contains(pokemon.front_shiny_female!) {
            arrayImages.append(pokemon.front_shiny_female!)
        }
        
    }
    
}


extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index path \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokedexCollectionViewCell
        let image = UIImage(data: arrayImages[indexPath.row])
        
        cell.imagePokemon.image = image
        
        
        
        return cell
    }
    
}

extension DetailViewController:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // addImages()
        // updateImages()
         self.collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.addImageElementToArray()
//        switch type {
//        case .insert:
//            self.collectionView.insertItems(at: [newIndexPath!])
//        case .delete:
//            self.collectionView.deleteItems(at: [indexPath!])
//        case .update:
//            self.collectionView.reloadItems(at: [indexPath!])
//        default:
//            self.collectionView.reloadData()
//        }
       
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.collectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.collectionView.cellForItem(at: index)!
        let position = self.collectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
            index.row = index.row+1
        }
        self.collectionView.scrollToItem(at: index, at: .left, animated: true )
    }
}
