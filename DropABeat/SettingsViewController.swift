//
//  SettingsViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/10/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKCoreKit
import ParseFacebookUtilsV4



class SettingsViewController: UIViewController {

    var parseLoginHelper: ParseLoginHelper!
    var window: UIWindow?

    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func logoutUser(sender: AnyObject) {
        PFUser.logOut()
        
        
        
        
                
        
        let loginViewController = PFLogInViewController()
        
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        
        
        

        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                
                FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if let fbid = result["id"] as? String {
                        let url = "https://graph.facebook.com/\(fbid)/picture?type=large"
                        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
                            let file = PFFile(data: data)
                            
                            let user = PFUser.currentUser()
                            user?["profilePicture"] = file
                            user?.saveInBackground()
                            
                            }.resume()
                    }
                })
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                // 3
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
                
                
            }
        }
        
        
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper

        
        
        
        
        UIView.transitionWithView(self.view.window!, duration: 1.0, options: .TransitionCrossDissolve, animations: { () -> Void in
            let oldState: Bool = UIView.areAnimationsEnabled()
            UIView.setAnimationsEnabled(false)
            self.view.window!.rootViewController = loginViewController
            UIView.setAnimationsEnabled(oldState)
            },
            completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
