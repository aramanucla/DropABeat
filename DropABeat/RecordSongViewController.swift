//
//  RecordSongViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/26/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSongViewController: UIViewController {

    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var beatNameField: UITextField!
    
    var testAudioPlayer: AVAudioPlayer?
    
    @IBAction func playButtonTapped(sender: UIButton) {
        
        if sender.titleLabel?.text == "Play" {
            sender.setTitle("Stop", forState: UIControlState.Normal)
            if audioRecorder?.recording == false {
                recordButton.enabled = false
                
                var error: NSError?
                
                testAudioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url,
                    error: &error)
                
                // Set delegate after audio player gets instantiated.
                testAudioPlayer?.delegate = self
                
                if let err = error {
                    println("audioPlayer error: \(err.localizedDescription)")
                } else {
                    testAudioPlayer?.play()
                }
            }
        } else { // When play button says "Stop" while playing
            playButton.setTitle("Play", forState: UIControlState.Normal)
            recordButton.enabled = true
            
            testAudioPlayer?.stop()
        }

    }
    
  
    @IBAction func recordButtonTapped(sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            sender.setTitle("Stop", forState: UIControlState.Normal)
            println((self.recordButton.titleLabel?.text)!)
            if audioRecorder?.recording == false {
                println("This gets called")
                playButton.enabled = false // Check this later.
                audioRecorder?.record()
                println("Recording")
            }
        } else {
            // STOP RECORDING
            audioRecorder?.stop()
            sender.setTitle("Record", forState: UIControlState.Normal)
            playButton.setTitle("Play", forState: UIControlState.Normal)
            playButton.enabled = true
        }

    }
    
    // Create variable to store NSURL to upload to Parse
    var soundFileURLHolder: NSURL?
    
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Instantiate the recorder.
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        var uuid = NSUUID().UUIDString
        
        let soundFilePath = docsDir.stringByAppendingPathComponent("\(uuid).caf")
        println(uuid)
        
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        soundFileURLHolder = soundFileURL
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        audioRecorder = AVAudioRecorder(URL: soundFileURL,
            settings: recordSettings as [NSObject : AnyObject], error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        } else {
            audioRecorder?.prepareToRecord()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecordSongViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Audio Record Encode Error")
    }
}



extension RecordSongViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Play Decode Error")
    }
    
}


