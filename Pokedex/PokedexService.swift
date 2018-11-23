//
//  PokedexService.swift
//  Pokedex
//
//  Created by Rodrigo on 07/11/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreData

class PokedexService {
    
    static let shared = PokedexService()
    
    
//    func loadPokemonList(_ dataController: DataController, _ completion: @escaping ( _ message: String?, _ pokemonDict:[[String:AnyObject]]?) -> Void){
//
//        let session = URLSession.shared
//
//        let url = URL(string: Constants.PokeAPI.APIBaseURL)!
//        let request = URLRequest(url: url)
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//            guard (error == nil) else {
//                completion(error.debugDescription, nil)
//                return
//            }
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
//                completion("Constants.ErrorMessage.TrySometime", nil)
//                return
//            }
//
//            guard let data = data else {
//                completion("Constants.ErrorMessage.DataNotFound", nil)
//                return
//            }
//
//            let parsedResult: [String:AnyObject]!
//            do {
//                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
//            } catch {
//                completion("Constants.ErrorMessage.InvalidData", nil)
//                return
//            }
//
//            guard let pokemonsDictionary = parsedResult["results"] as? [[String:AnyObject]] else {
//                    completion("Constants.ErrorMessage.PokemonNotFound", nil)
//                    return
//            }
//
//           //print(pokemonsDictionary)
//
//           // completion(nil, pokemonsDictionary)
//
//
//            for pokemonAny in pokemonsDictionary {
//                //  print("downnnlooo \(photo["name"])")
//
//                let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: dataController.viewContext)
//                let pokemon = NSManagedObject(entity: entity!, insertInto: dataController.viewContext) as! Pokemon
//
//
//                //Pokemon(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
//                //let pokemon = Pokemon(context: dataController.viewContext)
//                pokemon.name = pokemonAny["name"] as? String
//                pokemon.url = pokemonAny["url"] as? String
//                let urlArray = pokemon.url?.components(separatedBy: "/")
//                pokemon.identifier = urlArray![(urlArray?.count)! - 2]
//
//
////                do {
////           //         try dataController.viewContext.save()
////                } catch {
////                    print("Failed saving")
////                }
//
//
//            }
//            //try? dataController.viewContext.save()
//          //  completion("success")
//           // self.downloadImageFromPhotos(arrayPokemon, dataController: dataController)
//        }
//
//        task.resume()
//    }
    

    func loadPokemonList(_ dataController: DataController, _ completion: @escaping ( _ message: String?, _ pokemonDict:[[String:AnyObject]]?) -> Void){
        
        let session = URLSession.shared
        
        let url = URL(string: Constants.PokeAPI.APIBaseURL)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completion(error.debugDescription, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completion("Constants.ErrorMessage.TrySometime", nil)
                return
            }
            
            guard let data = data else {
                completion("Constants.ErrorMessage.DataNotFound", nil)
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completion("Constants.ErrorMessage.InvalidData", nil)
                return
            }
            
            guard let pokemonsDictionary = parsedResult["results"] as? [[String:AnyObject]] else {
                completion("Constants.ErrorMessage.PokemonNotFound", nil)
                return
            }
            
            //print(pokemonsDictionary)
            
            // completion(nil, pokemonsDictionary)
            
            
            for pokemonAny in pokemonsDictionary {
                //  print("downnnlooo \(photo["name"])")
                
                
                
                
                self.createPokemon(pokemonAny, dataController)
                
                
//                let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: dataController.viewContext)
//                let pokemon = NSManagedObject(entity: entity!, insertInto: dataController.viewContext) as! Pokemon
//
//
//                //Pokemon(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
//                //let pokemon = Pokemon(context: dataController.viewContext)
//                pokemon.name = pokemonAny["name"] as? String
//                pokemon.url = pokemonAny["url"] as? String
//                let urlArray = pokemon.url?.components(separatedBy: "/")
//                pokemon.identifier = urlArray![(urlArray?.count)! - 2]
                
                
                //                do {
                //           //         try dataController.viewContext.save()
                //                } catch {
                //                    print("Failed saving")
                //                }
                
                
            }
            //try? dataController.viewContext.save()
            //  completion("success")
            // self.downloadImageFromPhotos(arrayPokemon, dataController: dataController)
        }
        
        task.resume()
    }
    
    func createPokemon(_ pokemonAny:[String:AnyObject], _ dataController:DataController) {
        
        let urlString = pokemonAny["url"] as? String
        
        URLSession.shared.dataTask(with: URL(string: urlString!)!) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                return
            }
            
            
            let pokemon = Pokemon(context: dataController.viewContext)
            
            
            //Pokemon(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
            //let pokemon = Pokemon(context: dataController.viewContext)
            pokemon.name = pokemonAny["name"] as? String
            pokemon.url = urlString
            let urlArray = pokemon.url?.components(separatedBy: "/")
            pokemon.identifier = urlArray![(urlArray?.count)! - 2]
            
            if let sprites = parsedResult["sprites"] {
                pokemon.url_front_default      = self.checkUrl(sprites, key: "front_default")
                pokemon.url_back_default       = self.checkUrl(sprites, key: "back_default")
                pokemon.url_back_female        = self.checkUrl(sprites, key: "back_female")
                pokemon.url_back_shiny         = self.checkUrl(sprites, key: "back_shiny")
                pokemon.url_back_shiny_female  = self.checkUrl(sprites, key: "back_shiny_female")
                pokemon.url_front_female       = self.checkUrl(sprites, key: "front_female")
                pokemon.url_front_shiny        = self.checkUrl(sprites, key: "front_shiny")
                pokemon.url_front_shiny_female = self.checkUrl(sprites, key: "front_shiny_female")
                
                
//                if let urlString = sprites["front_default"] {
//                    if let urlString = urlString as? String {
//                        
//                        DispatchQueue.main.async {
//                            URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
//                                if error == nil {
//                                    pokemon.front_default = data!
//                                }
////                                do {
////
////                                    //try dataController.managedObjectContext?.save()
////                                } catch {
////                                    print("EEERRRRROOOOOOOO")
////                                }
//                                }.resume()
//                        }
//                        
//                    }
//                }
                
            }
            
            try? dataController.viewContext.save()
            }.resume()
    }
    
    func checkUrl(_ sprites: AnyObject, key:String) -> String? {
        if let url = sprites[key] {
            if let urlString = url as? String {
                if urlString.isValidURL {
                    return urlString
                }
            }
        }
        return nil
    }
//    func downloadImageFromPhotos(_ photos:[Pokemon], dataController:DataController) {
//        for photo in photos {
//            let totalPhotos = photos.count
//            var downloadedPokemons = 0
//            if let urlString = photo.url {
//
//
//
//
//                DispatchQueue.main.async {
//                    URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
//
//
//                        guard let data = data else {
//                           // completion(false, "Constants.ErrorMessage.DataNotFound", nil)
//                            return
//                        }
//
//                        let parsedResult: [String:AnyObject]!
//                        do {
//                            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
//                        } catch {
//                            // completion(false, "Constants.ErrorMessage.InvalidData", nil)
//                            return
//                        }
//                        if let sprites = parsedResult["sprites"] {
//                          //  self.downloadSprites(sprites, photo, dataController)
//                        }
////                        print(parsedResult["sprites"])
////                        print(parsedResult)
////                        if error == nil {
////                           // photo.front_shiny = data!
////                            print("downloaded \(photo.identifier)")
////                            //  try? dataController.viewContext.save()
////                        }
////                        if downloadedPokemons >= totalPhotos {
////                            print("downloadddddeeedd all photos")
////                        }
////                        downloadedPokemons += 1
//                        }.resume()
//                }
//            }
//        }
//
//    }
//
//    func downloadSprites(_ sprites:AnyObject!, _ pokemon:Pokemon, _ dataController:DataController) {
//
//        var totalDownloaded = 0
//
////        if pokemon.identifier == "460" {
////            print(pokemon)
////        }
//        if pokemon.identifier == "10060" {
//            print(pokemon)
//        }
//
//
//        if let urlString = sprites["back_default"] {
//            if (urlString as? String) != nil {
//                totalDownloaded += 1
//            //    self.checkFinishedDownload(totalDownloaded, dataController)
//            } else {
//
//                DispatchQueue.main.async {
//                    URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                        if error == nil {
//                            pokemon.back_default = data!
//                        }
//                        totalDownloaded += 1
//                    //    self.checkFinishedDownload(totalDownloaded, dataController)
//                        }.resume()
//                }
//            }
//        } else {
//            totalDownloaded += 1
//          //  self.checkFinishedDownload(totalDownloaded, dataController)
//        }
//
//
//
//    }
    
//    func checkFinishedDownload(_ totalDownloaded:Int, _ dataController:DataController) {
//        let totalImages = 8
//        if (totalDownloaded == totalImages) {
//            print("fim dos downloadis")
//
//            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(teste(_:)), userInfo: dataController, repeats: false)
////            DispatchQueue.main.async {
////                try? dataController.viewContext.save()
////            }
//        }
//    }
//
//    @objc func teste(_ timer: Timer) {
//
//        let dataController = timer.userInfo as! DataController
//        DispatchQueue.main.async {
//           // try? dataController.viewContext.save()
//        }
//    }
    
   
    
}

//
//if let urlString = sprites["back_female"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.back_female = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//if let urlString = sprites["back_shiny"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.back_shiny = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//if let urlString = sprites["back_shiny_female"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.back_shiny_female = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//
//if let urlString = sprites["front_default"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//
//                if pokemon.identifier == "10060" {
//                    print(pokemon)
//                }
//                if error == nil {
//                    pokemon.front_default = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//if let urlString = sprites["front_female"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.front_female = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//if let urlString = sprites["front_shiny"] {
//
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.front_shiny = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
//
//
//if let urlString = sprites["front_shiny_female"] {
//    if !self.checkUrl(urlString: urlString as? String) {
//        totalDownloaded += 1
//        self.checkFinishedDownload(totalDownloaded, dataController)
//    } else {
//
//        DispatchQueue.main.async {
//            URLSession.shared.dataTask(with: URL(string: urlString as! String)!) { (data, response, error) in
//                if error == nil {
//                    pokemon.front_shiny_female = data!
//
//                }
//                totalDownloaded += 1
//                self.checkFinishedDownload(totalDownloaded, dataController)
//                }.resume()
//        }
//    }
//} else {
//    totalDownloaded += 1
//    self.checkFinishedDownload(totalDownloaded, dataController)
//}
