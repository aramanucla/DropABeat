//
//  SettingsViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/10/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBAction func logoutUser(sender: AnyObject) {
        PFUser.logOut()
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
