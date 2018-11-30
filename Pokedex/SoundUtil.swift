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
    enum SoundName:String  {
        case favorite = "favorite"
        case notFavorite = "not_favorite"
        case finished = "finished"
        case tick = "tick"
    }
    
    static var player: AVAudioPlayer?
    
    static func playSound( _ fileName: SoundUtil.SoundName!) {
        guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: "wav") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            player.numberOfLoops = 1
            if fileName == .tick {
                player.numberOfLoops = -1
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func stopSound() {
        player?.stop()
        player = nil
    }
}
