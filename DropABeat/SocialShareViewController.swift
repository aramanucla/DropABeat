//
//  SocialShareViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/3/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Social
import FBSDKShareKit

class SocialShareViewController: UIViewController, FBSDKSharingDelegate {

    
    var url: NSURL?
    
    var videoURL: NSURL?
    
    var shareDialog = FBSDKShareDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareDialog.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareOnFacebook(sender: AnyObject) {
        
        if(url != nil){
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType:  SLServiceTypeFacebook)
        shareToFacebook.setInitialText("Check out this beat!")
        
        println(url)
        shareToFacebook.addURL(url)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
        }
        
        else
        {
            var video: FBSDKShareVideo = FBSDKShareVideo()
            video.videoURL = self.videoURL
            var content: FBSDKShareVideoContent = FBSDKShareVideoContent()
            content.video = video
            
            
            shareDialog.fromViewController = self
            shareDialog.shareContent = content
            
            shareDialog.show()
            
            
        }
    }

    
    @IBAction func shareOnTwitter(sender: AnyObject) {
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareToTwitter.setInitialText("Check out this beat!")
        shareToTwitter.addURL(url)
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!)
    {
        println("This shit completed homie")
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!)
    {
        println("This shit failed homie")
        println(error)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!)
    {
        println("this shit did Cancel homie")
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
