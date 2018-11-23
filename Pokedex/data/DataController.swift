//
//  DataController.swift
//  Pokedex
//
//  Created by Rodrigo on 08/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError((error?.localizedDescription)!)
            }
            completion?()
        }
    }
}
