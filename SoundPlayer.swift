//
//  SoundPlayer.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            fatalError("Could not find and play the sound file. \(error)")
        }
    }
}
