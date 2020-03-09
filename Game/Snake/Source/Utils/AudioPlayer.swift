//
//  AudioPlayer.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 23/05/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Foundation
import AVFoundation

public final class AudioPlayer
{
    public enum AudioFile
    {
        case clock
        case vizg
        case final
        case toasty
        
        var rawValue: (file: String, ext: String) {
            get {
                switch self {
                case .clock:
                    return ("zvukovoy-effekt-clock-fx",".mp3")
                case .vizg:
                    return ("vizg",".m4a")
                case .final:
                    return ("z_uki-pobeda-2", ".m4a")
                case .toasty:
                    return ("toasty_sound", ".mp3")
                }
            }
        }
    }
    
    private var player: AVAudioPlayer?
    
    public func playSound(audioFile: AudioFile, repeatly: Bool)
    {
        self.playSound(file: audioFile.rawValue.file, ext: audioFile.rawValue.ext, repeatly: repeatly)
    }
    
    private func playSound(file: String, ext: String, repeatly: Bool)
    {
        guard let url = Bundle.main.url(forResource: file, withExtension: ext)
            else {return}
        
        do{
            player?.stop()
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            if repeatly
            {
                player.numberOfLoops = -1
            }
            player.play()
            
        }
        catch let error
        {
            print(error.localizedDescription)
        }
    }
}
