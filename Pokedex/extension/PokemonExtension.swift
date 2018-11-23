//
//  PokemonExtension.swift
//  Pokedex
//
//  Created by Rodrigo on 13/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//
import Foundation
import UIKit

extension Pokemon {
    
//    func downloadImagePerfil_old() {
//        if let urlString = self.url {
//            DispatchQueue.main.async {
//                URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
//
//                    guard let data = data else {
//                        return
//                    }
//
//                    let parsedResult: [String:AnyObject]!
//                    do {
//                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
//                    } catch {
//                        return
//                    }
//                    if let sprites = parsedResult["sprites"] {
//                        self.url_back_default       = self.checkUrl(sprites, key: "back_default")
//                        self.url_back_female        = self.checkUrl(sprites, key: "back_female")
//                        self.url_back_shiny         = self.checkUrl(sprites, key: "back_shiny")
//                        self.url_back_shiny_female  = self.checkUrl(sprites, key: "back_shiny_female")
//                        self.url_front_female       = self.checkUrl(sprites, key: "front_female")
//                        self.url_front_shiny        = self.checkUrl(sprites, key: "front_shiny")
//                        self.url_front_shiny_female = self.checkUrl(sprites, key: "front_shiny_female")
//                        //try? self.managedObjectContext?.save()
//
//                        if let urlString = sprites["front_default"] {
//                            if let urlString = urlString as? String {
//
//                                DispatchQueue.main.async {
//                                    URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
//                                        if error == nil {
//                                            self.front_default = data!
//                                        }
//                                        do {
//
//                                            try self.managedObjectContext?.save()
//                                        } catch {
//                                            print("EEERRRRROOOOOOOO")
//                                        }
//                                        }.resume()
//                                }
//
//                            }
//                        }
//
//                    }
//
//
//                    }.resume()
//            }
//        }
//    }
    
    func downloadImagePerfil() {
        
        print("downloading")
        if let urlString = self.url_front_default {
            
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
                    if error == nil {
                        self.front_default = data!
                    }
                    self.save()
                    }.resume()
            }
            
            
            
        } else {
            self.front_default = UIImage(named: "not_found")?.pngData()
        }
        
        
    }
    
    func save() {
        do {
            
            try self.managedObjectContext?.save()
        } catch {
            print("EEERRRRROOOOOOOO")
        }
    }
    
    func downloadDetailImages() {
        if self.back_default == nil && self.url_back_default != nil {
            self.downloadImageFrom(self.url_back_default!) { (imageData) in
                self.back_default = imageData
            }
        }
        if self.back_female == nil && self.url_back_female != nil {
            self.downloadImageFrom(self.url_back_female!) { (imageData) in
                self.back_female = imageData
            }
        }
        if self.back_shiny == nil && self.url_back_shiny != nil {
            self.downloadImageFrom(self.url_back_shiny!) { (imageData) in
                self.back_shiny = imageData
            }
        }
        if self.back_shiny_female == nil && self.url_back_shiny_female != nil {
            self.downloadImageFrom(self.url_back_shiny_female!) { (imageData) in
                self.back_shiny_female = imageData
            }
        }
        if self.front_female == nil && self.url_front_female != nil {
            self.downloadImageFrom(self.url_front_female!) { (imageData) in
                self.front_female = imageData
            }
        }
        if self.front_shiny == nil && self.url_front_shiny != nil {
            self.downloadImageFrom(self.url_front_shiny!) { (imageData) in
                self.front_shiny = imageData
            }
        }
        if self.front_shiny_female == nil && self.url_front_shiny_female != nil {
            self.downloadImageFrom(self.url_front_shiny_female!) { (imageData) in
                self.front_shiny_female = imageData
            }
        }
    }
    
    private func downloadImageFrom(_ urlString:String,  _ completion: @escaping ( _ imageData: Data?) -> Void) {
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
                if error == nil {
                    completion(data!)
                } else {
                    completion(nil)
                }
           //     try? self.managedObjectContext?.save()
                }.resume()
        }
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
    
   
}

