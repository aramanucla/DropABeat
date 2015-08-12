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
        
        loginViewController.logInView?.logo = nil
        
        var logInLogoTitle = UILabel()
        logInLogoTitle.text = "Drop A Beat"
        logInLogoTitle.font = UIFont(name: "HelveticaNeue", size: 36)
        loginViewController.logInView?.logo = logInLogoTitle
        

        

        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                
                if user["authData"] != nil {
                
                FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if let fbid = result["id"] as? String {
                        let url = "https://graph.facebook.com/\(fbid)/picture?type=large"
                        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
                            let file = PFFile(data: data)
                            
                            let user = PFUser.currentUser()
                            user?["profilePicture"] = file
                            user?.saveInBackground()
                            
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                                })
                            })

                            
                            }.resume()
                    }
                })
                
                }
                
                else
                {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        })
                    })


                }
                
            }
        }
        
        
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper

        
        
        
       self.presentViewController(loginViewController, animated: true, completion: nil)
        
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
