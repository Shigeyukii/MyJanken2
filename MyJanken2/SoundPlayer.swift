//
//  SoundPlayer.swift
//  MyJanken2
//
//  Created by user on 2024/07/07.
//

import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    
    let onseiData = NSDataAsset(name: "janken")!.data
    
    var onseiPlayer: AVAudioPlayer!
    
    func onseiPlay() {
        do {
            
            onseiPlayer = try AVAudioPlayer(data: onseiData)
            
            onseiPlayer.play()
        } catch {
            print("音声プレイヤーでエラーが発生しました！")
        }
    }
    

}
