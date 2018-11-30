//
//  ImagesViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import CoreData

class ImagesViewController: UIViewController {
    var arrayImages:[Data] = []
    var dataController:DataController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
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
            pokemon.downloadDetailImages()
        }
    }

    @IBAction func dismissDetailViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewMoreDetailSegue", sender: self)
    }
    
    fileprivate func updateImages() {
        if arrayImages.count > 0 {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageViewController = segue.destination as? ImageViewController {
            if let indexPath = sender as? IndexPath {
                imageViewController.imageData = arrayImages[indexPath.row]
            }
        }
    }
    
    @objc func showDetail() {
        self.performSegue(withIdentifier: "ViewMoreDetailSegue", sender: self)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension ImagesViewController {
   
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

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokedexCollectionViewCell
        let image = UIImage(data: arrayImages[indexPath.row])
        
        cell.imagePokemon.image = image
        cell.imagePokemon.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
        cell.backgroundImageView.image = image
        cell.backgroundImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImageSegue", sender: indexPath)
    }
    
}

extension ImagesViewController:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         self.collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.addImageElementToArray()
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
