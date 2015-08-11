//
//  VideoRecorderViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/28/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Parse
import AssetsLibrary

class VideoRecorderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    var imagePicker = UIImagePickerController()
    var hasPresentedPicker = false
    
    let assetsLibrary = ALAssetsLibrary()
    
    var song: Song?
    
    var count: Int = 0
    
    func buttonAction(sender:UIButton!)
    {
        println("The Song is \(song)")
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        
        println("AHAHAHAHAHAHAHAHAHAHAHAHAHAH The song name is \(song)")
        
        if(count % 2 == 0){
        imagePicker.startVideoCapture()
            count++
        }
        
        else
        {
            
            imagePicker.stopVideoCapture()
            
        }
        
        println("Button tapped")
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:StopCurrentSong])
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if(hasPresentedPicker)
        {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            
            println("captureVideoPressed and camera available.")
            
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
                        var invisibleView = UIView(frame: CGRectMake(80, 40, imagePicker.view.frame.size.width, imagePicker.view.frame.size.height-200))
                        view.backgroundColor = UIColor.clearColor()
            
                        imagePicker.cameraOverlayView = invisibleView
            
            
                        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                        button.frame = CGRectMake(30, 300, 100, 90)
            
                        button.setImage(UIImage(named: "DropABeatButton"), forState: UIControlState.Normal)
            
//                        button.backgroundColor = UIColor.greenColor()
//                        button.setTitle("Test Button", forState: UIControlState.Normal)
                        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                        imagePicker.cameraOverlayView?.addSubview(button)
            
        
            hasPresentedPicker = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            println("Camera not available.")
        }
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
        
        let videoShareURL = info[UIImagePickerControllerReferenceURL] as! NSURL!
        
        println("The video share URL is  \(videoShareURL)")
        
        let tempVideoURL = info[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = tempVideoURL.relativePath
        
        var videoName = "temp"
        if let components = tempVideoURL.pathComponents as? [String] {
            if components.count > 2 {
                videoName = components[components.count - 2]
            }
        }
        
        videoName = videoName + ".mov"
        
        println("The tempVideo NSURL is \(tempVideoURL)")
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
            

            
        })
        
        
        let videoData = NSData(contentsOfURL: tempVideoURL)
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsDirectory: NSString = paths[0] as! NSString
        
        var tempPath: NSString = documentsDirectory.stringByAppendingPathComponent(videoName)

        if let result = videoData?.writeToFile(tempPath as String, atomically: false) {
            if result {
                println("Successfully copied video file to \(tempPath)")
            } else {
                println("Failed when writing to file")
            }
        } else {
            println("Didn't have video data to write")
        }
        
        
        assetsLibrary.writeVideoAtPathToSavedPhotosAlbum(tempVideoURL, completionBlock: { (assetURL, error) -> Void in
            if error != nil {
                println("Error occurred when writing video: \(error)")
            } else {
                
                let videoObject = PFObject(className: "Video")
                videoObject["user"] = PFUser.currentUser()
                videoObject["song"] = self.song
                videoObject["fileSystemPath"] = videoName
                videoObject["videoAssetURL"] = assetURL.absoluteString 
                
                videoObject.saveInBackgroundWithBlock { (success, error) -> Void in
                    
                    //Send message to freestyles view controller that a video has been added
                    NSNotificationCenter.defaultCenter().postNotificationName("didAddSong", object: nil)
                    
                }

                
                println("Saved video to URL: \(assetURL)")
            }
        })


        
    }
 
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(false, completion: { () -> Void in
            self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
        })
        
        
        
    }
    
    
}
