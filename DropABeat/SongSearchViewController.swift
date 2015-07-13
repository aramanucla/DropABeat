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

public var searchAudioPlayer = AVPlayer()


class SongSearchViewController: UIViewController {
    
    var songs: [PFObject] = []
    
    //An Array of Song IDs and an Array of Song Names
    var IDArray = [String]()
    var NameArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Query all of the songs
        var ObjectIDQuery = PFQuery(className: "Songs")
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray : [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            
            for i in 0...objectIDs.count-1
            {
                self.IDArray.append(objectIDs[i].valueForKey("objectId") as! String)
                self.NameArray.append(objectIDs[i].valueForKey("SongName") as! String)
            }
            
            
            
            
            
        })
    }
    
    ///I have to revisit this function 
    
  /*  func grabSong()
    {
        var SongQuery = PFQuery(className: "Songs")
        SongQuery.getObjectInBackgroundWithId(IDArray[TableView.cellForRowAtIndexPath(<#indexPath: NSIndexPath#>)], block: {
            (object : PFObject?, error : NSError?) -> Void in
            
            if let AudioFileURLTemp = object?.objectForKey("SongFile")?.url
            {
                searchAudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                searchAudioPlayer.play()
            }
            
            
            
        })
        
    }
    
    
    */

    
    @IBOutlet weak var TableView: UITableView!
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    func loadSongs()
    {
        var completionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
            self.songs = songArray as! [PFObject]
            self.TableView.reloadData()
        }
        SongSearchViewController.searchUsers(SearchBar.text, completionBlock: completionBlock)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSongs()
    }
    
    
        
    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
        -> PFQuery {
            /*
            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
            Regex can be slow on large datasets. For large amount of data it's better to store
            lowercased username in a separate column and perform a regular string compare.
            */
            var filteredSongQuery = PFQuery(className: "Songs")
                .whereKey("SongName",
                    matchesRegex: searchText, modifiers: "i")

            filteredSongQuery.orderByAscending("SongName")
            filteredSongQuery.limit = 20
            
            filteredSongQuery.findObjectsInBackgroundWithBlock(completionBlock)
            
            return filteredSongQuery
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
        cell.SongTitleLabel.text = song.objectForKey("SongName") as? String
        
        return cell
        

    }
    
    

    
}

extension SongSearchViewController: UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadSongs()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
//        return true
    }
    
    
}