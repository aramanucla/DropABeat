//
//  RecordSongViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/26/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import AudioToolbox

class RecordSongViewController: UIViewController, UITextFieldDelegate {
    
    var timerCount = 0
    var timerRunning = false
    var timer = NSTimer()
    
    
    func counting()
    {
        timerCount+=1
        timerLabel.text = "\(timerCount)"
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var beatNameField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func playButtonTapped(sender: UIButton) {
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        if sender.titleLabel?.text == "Play" {
            sender.setTitle("Stop", forState: UIControlState.Normal)
            if audioRecorder?.recording == false {
                recordButton.enabled = false
                
                var error: NSError?
                
                 NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: audioRecorder?.url, userInfo: [SongPlayStateKey:Playing])
                
                
                // Set delegate after audio player gets instantiated.
                
                
             
            }
        } else { // When play button says "Stop" while playing
            playButton.setTitle("Play", forState: UIControlState.Normal)
            recordButton.enabled = true
            
NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: audioRecorder?.url, userInfo: [SongPlayStateKey:Paused])        }

    }
    
  
    @IBAction func recordButtonTapped(sender: UIButton) {
        
        
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: nil, userInfo: [SongPlayStateKey:Paused])
        
        if sender.titleLabel?.text == "Record" {
            sender.setTitle("Stop", forState: UIControlState.Normal)
            println((self.recordButton.titleLabel?.text)!)
            if audioRecorder?.recording == false {
                println("This gets called")
                playButton.enabled = false // Check this later.
                audioRecorder?.record()
                println("Recording")
                
                
                if (timerRunning == false){
                    timerCount = 0
                    timerLabel.text = "0"
                    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
                    timerRunning = true
                }
                
            }
        } else {
            // STOP RECORDING
            audioRecorder?.stop()
            sender.setTitle("Record", forState: UIControlState.Normal)
            playButton.setTitle("Play", forState: UIControlState.Normal)
            playButton.enabled = true
            saveButton.enabled = true
            
            if(timerRunning == true){
                timer.invalidate()
                timerRunning = false
            }
        }

    }
    
    // Create variable to store NSURL to upload to Parse
    var soundFileURLHolder: NSURL?
    
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.hidden = true
        
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
    
    
    @IBAction func saveToParse(sender: AnyObject) {
        let songObject = PFObject(className: "Song")
        songObject["SongName"] = beatNameField.text
        songObject["numberOfLikes"] = 0
        songObject["usersWhoReportedSong"] = []
        songObject["user"] = PFUser.currentUser()
        
        var songData: NSData!
        var fileName: String? = nil
        
        if let unwrappedURL = audioRecorder?.url {
            songData = NSData(contentsOfURL: unwrappedURL)
            fileName = unwrappedURL.lastPathComponent
        }
        
        let songFile = PFFile(name:fileName, data: songData)
        
        songObject["SongFile"] = songFile
        
        songObject.saveInBackground()
        
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

extension RecordSongViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(textField: UITextField) {
        self.saveButton.hidden = false
        self.saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        beatNameField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


