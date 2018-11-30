//
//  StringExtensions.swift .swift
//  Pokedex
//
//  Created by Rodrigo on 12/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import UIKit
extension String {
    
    var isValidURL: Bool {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSMakeRange(0, self.endIndex.encodedOffset)
        if let urlString = detector.firstMatch(in: self, options: [], range: range) {
            return urlString.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    func capitalizingFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirst() {
        self = self.capitalizingFirst()
    }
    
}
