//
//  SongSearchViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/10/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//
//4GB x 2 sticks, 204-pin Macbook ram
import Foundation
import UIKit
import Parse
import AVKit
import AVFoundation
import ConvenienceKit


public var searchAudioPlayer = AVPlayer()


class SongSearchViewController: UIViewController, presentActionSheetDelegate {
    
    let defaultRange = 0...9
    let additionalRangeSize = 10
    
    //Only to pass the indexPath of the more button pressed form the table view cell class to this class
    var indexPathForSelectedMoreButton: NSIndexPath?
    
    
    var songs: [Song] = []
    

    
    var likes: [PFObject]? = []

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        
      //  SongPlayer.sharedInstance.queryAllSongs()
        super.viewDidLoad()
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    
    @IBAction func changeTableView(sender: AnyObject) {
        
        println("changeTableView gets called")
        
        self.loadSongs()
        
        
    }

    /************************STUFF IM TRYING TO DO WITH TIMELINE COMPONENT************/
    
//    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
//        // 1
//        ParseHelper.timelineRequestforCurrentUser(range) {
//            (result: [AnyObject]?, error: NSError?) -> Void in
//            // 2
//            let posts = result as? [Post] ?? []
//            // 3
//            completionBlock(posts)
//        }
//    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
        self.loadSongs()
    }
    
    
    func loadSongs()
    {
        var completionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
            self.songs = songArray as! [Song]
            
//            for song in self.songs{
//                if let username = song.user?.username!{
//           // self.uploadedByUserArray.append(username)
//                }
//            }
            
            self.tableView.reloadData()
        }
        self.searchUsers(SearchBar.text, completionBlock: completionBlock)
        
    }
    
    
    func searchUsers(searchText: String, completionBlock: PFArrayResultBlock) -> PFQuery
    {
        /*
        NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
        Regex can be slow on large datasets. For large amount of data it's better to store
        lowercased username in a separate column and perform a regular string compare.
        */
        var filteredSongQuery = PFQuery(className: "Song")
            .whereKey("SongName",
                matchesRegex: searchText, modifiers: "i")
        filteredSongQuery.includeKey("user")
        
        if(segmentedControl.selectedSegmentIndex == 1){
        filteredSongQuery.orderByDescending("createdAt")
        
        }
        
        else
        {
            filteredSongQuery.orderByDescending("numberOfLikes")

        }
    
        
        /**************STUFF THAT I WAS TRYNA DO WITH TIMELINECOMPONENT****************/
        
//        filteredSongQuery.skip = range.startIndex
//        filteredSongQuery.limit = range.endIndex - range.startIndex
        
        
        filteredSongQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
        return filteredSongQuery
    }
    
    //To present the action sheet (delegate function of songSearchTableViewCell
    func presentActionSheet(actionSheet: UIAlertController) -> Void
    {
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showReportOptions(cell: SongSearchTableViewCell)
    {
        indexPathForSelectedMoreButton = tableView.indexPathForCell(cell)
        self.performSegueWithIdentifier("showReportOptions", sender: self)
        
    }
    
    func showShareOptions(cell: SongSearchTableViewCell)->Void
    {
        indexPathForSelectedMoreButton = tableView.indexPathForCell(cell)
        self.performSegueWithIdentifier("showSongSocialShareOptions", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showVideoRecorderSegue")
        {
            var upcoming: VideoRecorderViewController = segue.destinationViewController as! VideoRecorderViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! SongSearchTableViewCell
            
            upcoming.song = cell.song!
            
            
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            
            
        }
        
        if (segue.identifier == "showReportOptions")
        {
            var upcoming: ReportSongViewController = segue.destinationViewController as! ReportSongViewController
                    
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPathForSelectedMoreButton!) as! SongSearchTableViewCell
            
            upcoming.song = cell.song!
            
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedMoreButton!, animated: true)
            
            indexPathForSelectedMoreButton = nil
        }
        
        if (segue.identifier == "showSongSocialShareOptions")
        {
            var upcoming: SocialShareViewController = segue.destinationViewController as! SocialShareViewController
            
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPathForSelectedMoreButton!) as! SongSearchTableViewCell
            
            if let cellSongURL = cell.song!.SongFile?.url{
            upcoming.url = NSURL(string: cellSongURL)
            }
            
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedMoreButton!, animated: true)
            
            indexPathForSelectedMoreButton = nil
        }

        
        
        
    }
    
    
}

extension SongSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongSearchCell") as! SongSearchTableViewCell
        
        let song = songs[indexPath.row]
        
        cell.delegate = self
        
       // cell.uploadedByUser.text = "Uploaded by " + self.uploadedByUserArray[indexPath.row]
            
        cell.song = song
        
       // cell.SongTitleLabel.text = song.objectForKey("SongName") as? String
        
       // cell.playPauseButton.tag = indexPath.row
        
        
        //Implement something that says, if cell.song is favorited (by checking in Parse)
        //Set likeButton.selected = true

        
        
        //Implement something just like LikeHelper.shouldLikeCellBeRed that says, if a song
        
        return cell
        
        
    }
    
    
    
    
    
}

extension SongSearchViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadSongs()
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        //        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

    }
    
    
}


extension SongSearchViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showVideoRecorderSegue", sender: self)
    }
    
    
    
}











