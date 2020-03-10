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
        case action
        case death01
        case death02
        case eat01
        case eat02
        case eat03
        case gameover
        case startorend01
        
        var rawValue: (file: String, ext: String) {
            get {
                switch self {
                case .action:
                return ("action",".wav")
                case .death01:
                return ("death01",".wav")
                case .death02:
                return ("death02",".wav")
                case .eat01:
                return ("eat01",".wav")
                case .eat02:
                return ("eat02",".wav")
                case .eat03:
                return ("eat03",".wav")
                case .gameover:
                return ("gameover",".wav")
                case .startorend01:
                return ("start-or-end01",".wav")
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
