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


class VideoRecorderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    var imagePicker = UIImagePickerController()
    
    var song: Song?
    
    var count: Int = 0
    
    func buttonAction(sender:UIButton!)
    {
        println("The Song is \(song)")
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        
        
        if(count % 2 == 0){
        imagePicker.startVideoCapture()
            count++
        }
        
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:StopCurrentSong])
            imagePicker.stopVideoCapture()
            
        }
        
        println("Button tapped")
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:StopCurrentSong])
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            
            println("captureVideoPressed and camera available.")
            
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
                        var invisibleView = UIView(frame: CGRectMake(40, 40, imagePicker.view.frame.size.height, imagePicker.view.frame.size.height-200))
                        view.backgroundColor = UIColor.clearColor()
            
                        imagePicker.cameraOverlayView = invisibleView
            
            
                        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                        button.frame = CGRectMake(100, 100, 100, 50)
                        button.backgroundColor = UIColor.greenColor()
                        button.setTitle("Play Beat & Record", forState: UIControlState.Normal)
                        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                        imagePicker.cameraOverlayView?.addSubview(button)
            
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            println("Camera not available.")
        }
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let tempImage = editingInfo[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = tempImage.relativePath
        
        self.dismissViewControllerAnimated(true, completion: {})
        
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {
        
        })
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
    }
    
    
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    
            dismissViewControllerAnimated(true, completion: nil)
            performSegueWithIdentifier("returnToDropABeatViewController", sender: self)
            
            
        }
    
    
}
