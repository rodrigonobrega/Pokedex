//
//  PokedexTableViewController.swift
//  Pokedex
//
//  Created by Rodrigo on 07/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import CoreData

class PokedexTableViewController: UITableViewController {

    var dataController:DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    
    var pokemonDictionary:[[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupFetchedResultsController()
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            
            PokedexService.shared.loadPokemonList(dataController) { (message ,pokemonDictionary)  in
                if let message = message {
                    if message != "success" {
                        self.showMessage(message)
                    }
                } else if let pokemonDictionary = pokemonDictionary {
                    self.pokemonDictionary = pokemonDictionary
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.startAddPokemon()
                    })

                }
            }
        }
    }
    
    func startAddPokemon() {
        
       
        
                    for pokemonAny in pokemonDictionary {
                        //  print("downnnlooo \(photo["name"])")
        
                        let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: dataController.viewContext)
                        let pokemon = NSManagedObject(entity: entity!, insertInto: dataController.viewContext) as! Pokemon
        
        
                        //Pokemon(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
                        //let pokemon = Pokemon(context: dataController.viewContext)
                        let name = pokemonAny["name"] as? String
                        
                        pokemon.name = name?.capitalizingFirst()
                        pokemon.url = pokemonAny["url"] as? String
                        let urlArray = pokemon.url?.components(separatedBy: "/")
                        pokemon.identifier = urlArray![(urlArray?.count)! - 2]
        
                        
        //                do {
        //           //         try dataController.viewContext.save()
        //                } catch {
        //                    print("Failed saving")
        //                }
        
        
                    }

    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: "name", cacheName: "tableCache")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        self.navigationItem.prompt = "\(fetchRequest.affectedStores?.count ?? 0) pokemons found"
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    func showMessage(_ message:String) {
        let alert = UIAlertController(title: "Pokedex", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension PokedexTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "detailPokemonSegue", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? ImagesViewController {
            detailViewController.dataController = self.dataController
            detailViewController.pokemon = sender as? Pokemon
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PokedexTableViewCell
        
        let pokemon = fetchedResultsController.object(at: indexPath)
        
        cell.pokemon = pokemon

        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension PokedexTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == .insert {
            print("\(sectionIndex) - sectio")
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        }
        if type == .update {
            print("\(sectionIndex) - sections")
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)

        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        UIView.performWithoutAnimation {
        if type == .insert {
            print("\(newIndexPath) - insert \(indexPath)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
        if type == .update {
            
          //  let visible = tableView.indexPathsForVisibleRows?.contains(indexPath!)
          //  if visible! {
                tableView.reloadRows(at: [indexPath!], with: .none)
//            } else {
//                print("not updates")
//            }
        }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        //try? self.dataController.viewContext.save()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
