//
//  PokedexService.swift
//  Pokedex
//
//  Created by Rodrigo on 07/11/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PokedexService {
    
    static let shared = PokedexService()
    
    
    func loadPokemonList(_ completion: @escaping ( _ success: Bool, _ message: String?, _ pokemons: [[String:AnyObject]]?) -> Void){
        
        let session = URLSession.shared
        let urlString = "https://pokeapi.co/api/v2/pokemon/"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completion(false, error.debugDescription, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completion(false, "Constants.ErrorMessage.TrySometime", nil)
                return
            }
            
            guard let data = data else {
                completion(false, "Constants.ErrorMessage.DataNotFound", nil)
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completion(false, "Constants.ErrorMessage.InvalidData", nil)
                return
            }

            guard let pokemonsDictionary = parsedResult["results"] as? [[String:AnyObject]] else {
                    completion(false, "Constants.ErrorMessage.PokemonNotFound", nil)
                    return
            }
            
            print(pokemonsDictionary)
            
            completion(true, nil, pokemonsDictionary)
        }
        
        task.resume()
    }
    
}
