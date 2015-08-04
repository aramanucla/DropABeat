//
//  LoginViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/3/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse
//import ParseUI

class LoginViewController: UIViewController {//PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    
//    var loginViewController: PFLogInViewController! = PFLogInViewController()
//    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
//    
//    
//    
//    //Mark: Parse Login
//    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
//        if(!username.isEmpty || !password.isEmpty)
//        {
//            return true
//        }
//        
//        else
//        {
//            return false
//        }
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        
//self.performSegueWithIdentifier("loggedIn", sender: self)
//    
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
//        
//        println("failed to log in")
//        
//    }
//    
//    
//    
//    //Mark: Parse Signup
//    
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
//        self.performSegueWithIdentifier("loggedIn", sender: self)
//        
//    }
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
//        println("Failed to sign up")
//    }
//    
//    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
//        println("user dismissed sign up")
//    }
//    
//
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        if(PFUser.currentUser() == nil)
//        {
//            self.loginViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
//        }
//        
//        
//        var logInLogoTitle = UILabel()
//        logInLogoTitle.text = "Drop A Beat"
//        self.loginViewController.logInView?.logo = logInLogoTitle
//        self.loginViewController.delegate = self
//        
//        
//        var signUpLogoTitle = UILabel()
//        signUpLogoTitle.text = "Drop A Beat"
//        self.signUpViewController.signUpView?.logo = signUpLogoTitle
//        self.signUpViewController.delegate = self
//        self.loginViewController.signUpController = self.signUpViewController
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
