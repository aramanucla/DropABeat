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
    var myPublishedBeats: [PFObject] = []
    
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
        var likedSongsCompletionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
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
        
        var likedSongCompletionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
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
        
        var mySongCompletionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
            self.myPublishedBeats = songArray as! [PFObject]
            for song in self.myPublishedBeats {
                
                let index = find(self.songsArray, song as! Song)
                
                if(index == nil)
                {
                    self.songsArray.append(song as! Song)
                }
                
            }
            self.tableView.reloadData()
        }
        
        self.findFavorites(likedSongCompletionBlock, mySongCompletionBlock: mySongCompletionBlock)
        
    }
    
    func findFavorites(likedSongCompletionBlock: PFArrayResultBlock, mySongCompletionBlock: PFArrayResultBlock)
    {
        
        var favoriteSongQuery = PFQuery(className: "Like").whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        favoriteSongQuery.includeKey("toSong")
        
        
        var mySongQuery = PFQuery(className: "Song").whereKey("user", equalTo: PFUser.currentUser()!)
        
        mySongQuery.findObjectsInBackgroundWithBlock(mySongCompletionBlock)
        
//        var songQuery = PFQuery(className: "Song").whereKey("objectId", matchesKey: "toSong", inQuery: favoriteSongQuery)
        
        
//        filteredSongQuery.orderByAscending
//        filteredSongQuery.limit = 20
//        
        favoriteSongQuery.findObjectsInBackgroundWithBlock(likedSongCompletionBlock)
        
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
        
        if(segue.identifier == "showVideoRecorderSegue")
        {
            var upcoming: VideoRecorderViewController = segue.destinationViewController as! VideoRecorderViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! BeatsTableViewCell
            
            println(cell.song)
            
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
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if(songsArray[indexPath.row].user == PFUser.currentUser()! )
        {
            return true
        }
        
        else
        {
            return false
        }
       
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let query = PFQuery(className: "Song")
            query.whereKey("user", equalTo: PFUser.currentUser()!).whereKey("objectId", equalTo: songsArray[indexPath.row].objectId!)
            
            
            var reloadDataCompletionBlock = {(success: Bool, error: NSError?)->Void in
                self.songsArray.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.reloadData()}
            
            var findSongCompletionBlock = {(results: [AnyObject]?, error: NSError?) -> Void in
                if let results = results as? [PFObject]{
                    for result in results{
                        
                        result.deleteInBackgroundWithBlock(reloadDataCompletionBlock)
                    }
                }
                
            
            }
            
            
            query.findObjectsInBackgroundWithBlock(findSongCompletionBlock)
            
            
            
        }
    }
}


extension BeatsAndFreestylesViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showVideoRecorderSegue", sender: self)
    }
    
    
    
}


