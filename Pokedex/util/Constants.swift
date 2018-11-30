//
//  Constants.swift
//  Pokedex
//
//  Created by Rodrigo on 08/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//


import Foundation

struct Constants {
    
    // MARK: base url
    struct PokeAPI {
        static let APIBaseURL = "https://pokeapi.co/api/v2/pokemon/"
    }
    
    struct Pokedex {
        static let messageActivityShare = "\nSharing Pokemon"
    }
    
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    
    
    // Mark: Error messages
    struct ErrorMessage {
        static let APINotDefined = "Please inform your API Key in Constants File before init"
        static let errorDescription = "Error Description :"
        static let TrySometime = "Please try again in sometime"
        static let DataNotFound = "Data not found, please try again in sometime"
        static let InvalidData = "Return invalid data, please try again in sometime"
        static let PokemonNotFound = "Pokemon not found, please try again in sometime"
    }
    
    struct PokemonImage {
        static let frontDefault = "front_default"
        static let backDefault = "back_default"
        static let backFemale = "back_female"
        static let backShiny = "back_shiny"
        static let backShinyFemale = "back_shiny_female"
        static let frontFemale = "front_female"
        static let frontShiny = "front_shiny"
        static let frontShinyFemale = "front_shiny_female"
    }
    
    struct SoundExtension {
        static let wav = "wav"
    }
}
