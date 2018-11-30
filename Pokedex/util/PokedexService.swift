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
    
    private let results = "results"
    private let urlPerfil = "url"
    private let urlSeparator = "/"
    private let pokemonName = "name"
    private let pokemonSprites = "sprites"
    
    func loadPokemonList(_ dataController: DataController, _ completion: @escaping ( _ success:Bool, _ message: String?, _ pokemonDict:[[String:AnyObject]]?) -> Void){
        
        let session = URLSession.shared
        
        let url = URL(string: Constants.PokeAPI.APIBaseURL)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completion(false, error.debugDescription, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completion(false, Constants.ErrorMessage.TrySometime, nil)
                return
            }
            
            guard let data = data else {
                completion(false, Constants.ErrorMessage.DataNotFound, nil)
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completion(false, Constants.ErrorMessage.InvalidData, nil)
                return
            }
            
            guard let pokemonsDictionary = parsedResult[self.results] as? [[String:AnyObject]] else {
                completion(false, Constants.ErrorMessage.PokemonNotFound, nil)
                return
            }
            
            
            for pokemonAny in pokemonsDictionary {
                self.createPokemon(pokemonAny, dataController)
            }
            
           completion(true, "\(pokemonsDictionary.count)", nil)
        }
        
        task.resume()
    }
    
    func createPokemon(_ pokemonAny:[String:AnyObject], _ dataController:DataController) {
        
        let urlString = pokemonAny[self.urlPerfil] as? String
        
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
            let name = pokemonAny[self.pokemonName] as? String
            
            pokemon.name = name?.capitalizingFirst()
            pokemon.url = urlString
            let urlArray = pokemon.url?.components(separatedBy: self.urlSeparator)
            pokemon.identifier = urlArray![(urlArray?.count)! - 2]
            pokemon.base_experience = parsedResult[Constants.PokemonAttributes.baseExperience] as! Int32
            pokemon.height = parsedResult[Constants.PokemonAttributes.height] as! Int32
            pokemon.weight = parsedResult[Constants.PokemonAttributes.weight] as! Int32
            
            if let sprites = parsedResult[self.pokemonSprites] {
                pokemon.url_front_default      = self.checkUrl(sprites, key: Constants.PokemonImage.frontDefault)
                pokemon.url_back_default       = self.checkUrl(sprites, key: Constants.PokemonImage.backDefault)
                pokemon.url_back_female        = self.checkUrl(sprites, key: Constants.PokemonImage.backFemale)
                pokemon.url_back_shiny         = self.checkUrl(sprites, key: Constants.PokemonImage.backShiny)
                pokemon.url_back_shiny_female  = self.checkUrl(sprites, key: Constants.PokemonImage.backShinyFemale)
                pokemon.url_front_female       = self.checkUrl(sprites, key: Constants.PokemonImage.frontFemale)
                pokemon.url_front_shiny        = self.checkUrl(sprites, key: Constants.PokemonImage.frontShiny)
                pokemon.url_front_shiny_female = self.checkUrl(sprites, key: Constants.PokemonImage.frontShinyFemale)
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
}
