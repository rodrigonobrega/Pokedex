//
//  PokedexCollectionViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import CoreData

class PokedexCollectionViewController: UICollectionViewController {
    
    var dataController:DataController!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Pokemon> = {
        
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "favorite == true")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "collectionCache")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? self.dataController.viewContext.save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            PokedexService.shared.loadPokemonList(dataController) { (message, pokemonDictionary) in
                if let message = message {
                    self.showMessage(message)
                }
            }
            
        }
        
    }
    
    func showMessage(_ message:String) {
        let alert = UIAlertController(title: "Virtual Tourist", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension PokedexCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "detailPokemonSegue", sender: pokemon)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            detailViewController.dataController = self.dataController
            detailViewController.pokemon = sender as? Pokemon
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!  PokedexCollectionViewCell
        //let cell = collectionView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UICollectionViewCell
        
        let pokemon = fetchedResultsController.object(at: indexPath)
     //   cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cell.labelName.text = pokemon.name
        cell.labelName.layer.cornerRadius = cell.labelName.frame.height/2
        cell.labelName.layer.masksToBounds = true
        cell.labelName.layer.borderColor = UIColor.gray.cgColor
        cell.labelName.layer.borderWidth = 1.0

        if let imageData = pokemon.front_default {
            cell.imagePokemon.image = UIImage(data: imageData)
        } else {
            pokemon.downloadImagePerfil()
        }
    
//        cell.labelName?.text = pokemon.name
//        cell.imageViewPokemon.image = UIImage()
//        cell.pokemon = pokemon
//
//        if let imageData = pokemon.front_default {
//            cell.imageViewPokemon.image = UIImage(data: imageData)
//        } else {
//            pokemon.downloadImagePerfil()
//        }
//
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension PokedexCollectionViewController : NSFetchedResultsControllerDelegate {
    
   
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            self.collectionView.deleteItems(at: [indexPath!])
        case .update:
            self.collectionView.reloadItems(at: [indexPath!])
        default:
            self.collectionView.reloadData()
        }
    }
    
}
