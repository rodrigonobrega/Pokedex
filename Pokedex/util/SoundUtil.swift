//
//  SoundUtil.swift
//  Pokedex
//
//  Created by Rodrigo on 29/11/18.
//  Copyright © 2018 Foxcode. All rights reserved.
//

import AVFoundation
import AudioToolbox

class SoundUtil {
    static let playOneTime = 1
    static let playInfinity = -1
    
    enum SoundName:String  {
        case favorite =  "favorite"
        case notFavorite = "not_favorite"
        case finished = "finished"
        case tick = "tick"
    }
    
    static var player: AVAudioPlayer?
    
    static func playSound( _ fileName: SoundUtil.SoundName!) {
        guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension:Constants.SoundExtension.wav) else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            player.numberOfLoops = playOneTime
            if fileName == .tick {
                player.numberOfLoops = playInfinity
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
