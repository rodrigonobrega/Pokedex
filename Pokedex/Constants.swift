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
    
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        //            static let Status = "stat"
        //            static let Photos = "photos"
        //            static let Photo = "photo"
        //            static let Title = "title"
        //            static let MediumURL = "url_m"
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
        static let PhotoNotFound = "Cannot find photos, please try again in sometime"
    }
}
