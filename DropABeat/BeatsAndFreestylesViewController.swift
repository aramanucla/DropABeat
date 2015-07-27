//
//  MyBeats.swift
//  DropABeat
//
//  Created by Alex Raman on 7/23/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse


class BeatsAndFreestylesViewController: UIViewController, reloadDataDelegate {

    
    var myBeats: [PFObject] = []
    var myFreestyles = []
    var songsArray = [Song]()
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.loadFavorites()
    }
    
    
    func loadFavorites()
    {
        var completionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
            self.myBeats = songArray as! [PFObject]
            for like in self.myBeats {
                
                let index = find(self.songsArray, like.objectForKey("toSong") as! Song)
    
                if(index == nil)
                {
                self.songsArray.append(like.objectForKey("toSong") as! Song)
                }
                
            }
            self.tableView.reloadData()
        }
        self.findFavorites(completionBlock)
        
    }
    
    func findFavorites(completionBlock: PFArrayResultBlock) -> PFQuery
    {
        
        var favoriteSongQuery = PFQuery(className: "Like").whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        favoriteSongQuery.includeKey("toSong")
        
        
//        var songQuery = PFQuery(className: "Song").whereKey("objectId", matchesKey: "toSong", inQuery: favoriteSongQuery)
        
        
//        filteredSongQuery.orderByAscending
//        filteredSongQuery.limit = 20
//        
        favoriteSongQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
        
        return favoriteSongQuery
        
        
    }

    func reload(song: Song)
    {
        let index = find(self.songsArray, song)
        self.songsArray.removeAtIndex(index!)
        
        tableView.reloadData()
    }
    
    
    @IBAction func changeTableView(sender: AnyObject) {
        tableView.reloadData()
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "DropThisBeat")
        {
            var upcoming: DropThisBeatViewController = segue.destinationViewController as! DropThisBeatViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! BeatsTableViewCell
            
            upcoming.song = cell.song!
            
            
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
        }
    }

    
    
    
    @IBAction func addBeat(sender: AnyObject) {
        self.performSegueWithIdentifier("addBeatSegue", sender: self)
        
    }
    
    
    
}

extension BeatsAndFreestylesViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (segmentedController.selectedSegmentIndex == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BeatsTableViewCell") as! BeatsTableViewCell
            
            // let song = myBeats[indexPath.row].objectForKey("toSong") as? Song
            
            let song = songsArray[indexPath.row]

            cell.song = song
            
            cell.SongTitleLabel.text = song.objectForKey("SongName") as? String
            
            LikeHelper.shouldLikeBeRed(cell, user: PFUser.currentUser()!, song: cell.song!)
            
            cell.delegate = self
            
            return cell
            
        }
        
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BeatsTableViewCell") as! BeatsTableViewCell
            
            // let song = myBeats[indexPath.row].objectForKey("toSong") as? Song
            
            let song = songsArray[indexPath.row]
            
            cell.song = song
            
            cell.SongTitleLabel.text = (song.objectForKey("SongName") as? String)! 
            
            cell.delegate = self
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsArray.count
    }
}


extension BeatsAndFreestylesViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("DropThisBeat", sender: self)
    }
    
    
    
}

