//
//  SocialShareViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/3/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Social

class SocialShareViewController: UIViewController {

    
    var url: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText("Check out this beat!")
        
        println(url)
        shareToFacebook.addURL(url)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }

    
    @IBAction func shareOnTwitter(sender: AnyObject) {
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareToTwitter.setInitialText("Check out this beat!")
        shareToTwitter.addURL(url)
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
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
