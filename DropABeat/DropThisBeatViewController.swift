//
//  DropThisBeatViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/13/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit

class DropThisBeatViewController: UIViewController {

    
    var songNumber: Int = -1
    
    var mySongPlayer = SongPlayer()
    
    
    @IBOutlet weak var playPauseOutlet: UIButton!
    
    override func viewDidLoad() {
        mySongPlayer.queryAllSongs()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dropThisBeat(sender: AnyObject) {
        
        playPauseOutlet.setTitle("Pause", forState: UIControlState.Normal)
        mySongPlayer.grabSongAndPlay(selectedSongNumber: mySongPlayer.IDArray.count - 1 - songNumber)
    }

    @IBAction func playPauseButton(sender: AnyObject) {
        
        if (mySongPlayer.playPause())
        {
            playPauseOutlet.setTitle("Play", forState: UIControlState.Normal)
        }
            
        else
        {
            playPauseOutlet.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    @IBAction func restart(sender: AnyObject) {
        
        mySongPlayer.restart()
        playPauseOutlet.setTitle("Pause", forState: UIControlState.Normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dropThisNewBeat(sender: AnyObject) {
        mySongPlayer.grabSongAndPlay(selectedSongNumber: songNumber)
    }
    
    
    
    
    
}
