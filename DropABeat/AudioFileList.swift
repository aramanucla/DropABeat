//
//  AudioFileList.swift
//  DropABeat
//
//  Created by Alex Raman on 7/8/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


struct AudioFileList
{
    

    let AudioFileArray = ["Kanye West - Gold Digger", "Fort Minor - Remember the Name", "Childish Gambino - 3005", "Drake - Energy", "Drake - Zero to One Hundred", "Meek Mill - Levels", "Nicki Minaj - Truffle Butter", "Bobby Shmurda - Hot Nigga"]
    
    
    
    func randomSong() -> String
    {
        var unsignedArrayCount = UInt32(AudioFileArray.count)
        var unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        var randomNumber = Int(unsignedRandomNumber)
        
        return AudioFileArray[randomNumber]
    }
}