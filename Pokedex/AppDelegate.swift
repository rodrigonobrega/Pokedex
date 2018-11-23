//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Rodrigo on 07/11/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var showErrorDescription:Bool = true
    var window: UIWindow?

    private static let modelName = "Pokedex"
    
    let dataController = DataController(modelName: AppDelegate.modelName)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()
        if let tabBarViewController = window?.rootViewController as? PokedexTabBarViewController {
            tabBarViewController.dataController = dataController
        }

        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppDelegate.modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            self.printErrorDescription(error: error)
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveViewContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                self.printErrorDescription(error: error)            }
        }
    }
    
    func printErrorDescription(error: Error?) {
        if showErrorDescription {
            if let error = error as NSError? {
                print("\(Constants.ErrorMessage.errorDescription) \(error), \(error.userInfo)")
            }
        }
    }
}

