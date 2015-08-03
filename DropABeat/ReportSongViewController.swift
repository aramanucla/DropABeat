//
//  ReportSongViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 8/2/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse

class ReportSongViewController: UIViewController {
    
    var song: Song?
    
    var typesOfReportsArray: [String] = ["Beat contains copyrighted material", "Beat contains sexually explicit content", "Beat sound quality is bad", "This beat should not be on DropABeat"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
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

extension ReportSongViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesOfReportsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportSongTableViewCell") as! ReportSongTableViewCell
        
        cell.reportType.text = typesOfReportsArray[indexPath.row]
        
        return cell
    }
}


extension ReportSongViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        self.song?.incrementKey("numberOfReports", byAmount: 1)
//        song?.saveInBackgroundWithBlock({ (success, error) -> Void in
//            if(self.song?.numberOfReports > 5)
//            {
//                self.song?.deleteInBackground()
//            }
//        })
        
        
        self.song?.usersWhoReportedSong.append(PFUser.currentUser()!)
        self.song?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if(self.song?.usersWhoReportedSong.count > 4)
            {
                self.song?.deleteInBackgroundWithBlock(nil)
            }
        })
        
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
        let alertController: UIAlertController = UIAlertController(title: "Thank You", message: "This beat will be reviewed", preferredStyle: UIAlertControllerStyle.Alert)
        let doneAction: UIAlertAction = UIAlertAction(title: "Done", style: .Cancel) { (ACTION) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
                
    }
}