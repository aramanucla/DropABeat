//
//  MyBeats.swift
//  DropABeat
//
//  Created by Alex Raman on 7/23/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer
import AVFoundation

class BeatsAndFreestylesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  reloadDataDelegate, presentShareActionSheetDelegate {
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    var indexPathForSelectedMoreButton: NSIndexPath?
    
    var stringsOfVideoPaths: [String] = []
    var stringsOfAssetURLs: [NSString] = []
    
    var myNSFileManager = NSFileManager()
    
    var myFreestyleSongNames: [String] = []
    var songsArray = [Song]()
    var videoArray = [Video]()
    
    
    var didViewAppear: Bool = true
    var didAddSong: Bool = false
    var oldEndCount: Int = 0
    
    var moviePlayerController: MPMoviePlayerController!
    
    //  var uploadedByUserArray = [String]()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var myProfilePicture: UIImageView!
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func profilePictureButtonTapped(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myProfilePicture.contentMode = .ScaleAspectFit
            myProfilePicture.image = pickedImage
            
            // upload image
            let imageData = UIImagePNGRepresentation(pickedImage)
            let imageFile = PFFile(name:"image.png", data:imageData)
            let user = PFUser.currentUser()
            user?["profilePicture"] = imageFile
            user?.saveInBackground()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //Set up a listener for didAddSong a.k.a when a video was added
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setDidAddSongToTrue:", name: "didAddSong", object: nil)
        // Do any additional setup after loading the view.
        
         imagePicker.delegate = self
        
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tableView.addSubview(activityIndicator)
        tableView.bringSubviewToFront(activityIndicator)
        
        
        if let file = PFUser.currentUser()?["profilePicture"] as? PFFile, urlString = file.url, url = NSURL(string: urlString){
            myProfilePicture.sd_setImageWithURL(url, placeholderImage: nil)
        }
        
        
        self.myProfilePicture.layer.cornerRadius = self.myProfilePicture.frame.size.width / 2
        self.myProfilePicture.clipsToBounds = true
        self.myProfilePicture.layer.borderWidth = 3.0;
        self.myProfilePicture.layer.borderColor = UIColor.whiteColor().CGColor

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        
        super.viewDidAppear(animated)
        
        //Adds video at fileSystemPath to stringsOfVideoPaths Array
        
        if(didViewAppear || didAddSong){
            var videoQuery = PFQuery(className: "Video")
            
            videoQuery.whereKey("user", equalTo: PFUser.currentUser()!)
            videoQuery.includeKey("song")
            
            var completionBlock = { (videos: [AnyObject]?, error: NSError?) -> Void in
                
                if let videos = videos as? [PFObject] {
                    
                    
                    for self.oldEndCount; self.oldEndCount < videos.count; self.oldEndCount++
                    {
                        
                        if let assetURL = videos[self.oldEndCount]["videoAssetURL"] as? NSString
                        {
                            //Append the fetched videos to videoArray
                            
                        self.videoArray.append((videos[self.oldEndCount] as? Video)!)
                            self.stringsOfAssetURLs.append(assetURL)
                        }
                        
                        if let fileURLPath = videos[self.oldEndCount]["fileSystemPath"] as? String
                        {
                            self.stringsOfVideoPaths.append(fileURLPath)
                        }
                        
                        if let song = videos[self.oldEndCount]["song"] as? PFObject{
                            var title = song["SongName"] as? String
                            self.myFreestyleSongNames.append(title!)
                        }
                    }
                    
                    
                }
                
                self.oldEndCount = self.myFreestyleSongNames.count
                self.didViewAppear = false
                self.didAddSong = false
            }
            
            
            
            
            videoQuery.findObjectsInBackgroundWithBlock(completionBlock)
            
        }
        
        
        self.loadFavorites()
    }
    
    
    
    //To requery the videos if a video was added
    func setDidAddSongToTrue(notification: NSNotification)
    {
        self.didAddSong = true
        self.viewDidAppear(true)
        tableView.reloadData()
    }
    
    //Delegate function of BeatsTableViewCell
    func showReportOptions(cell: BeatsTableViewCell)
    {
        indexPathForSelectedMoreButton = self.tableView.indexPathForCell(cell)
        self.performSegueWithIdentifier("showMoreReportOptions", sender: self)
        
    }
    
    func presentActionSheet(actionSheet: UIAlertController) -> Void
    {
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showShareOptions(cell: BeatsTableViewCell)->Void
    {
        indexPathForSelectedMoreButton = self.tableView.indexPathForCell(cell)
        self.performSegueWithIdentifier("showSocialShareOptions", sender: self)
    }
    
    func showVideoShareOptions(cell: FreestylesTableViewCell)->Void
    {
        indexPathForSelectedMoreButton = self.tableView.indexPathForCell(cell)
        self.performSegueWithIdentifier("showSocialShareOptions", sender: self)
    }
    
    
    
    func loadFavorites() {
        let likesQuery = PFQuery(className: "Like")
        likesQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        likesQuery.includeKey("toSong")
        
        let mySongsQuery = PFQuery(className: "Song")
        mySongsQuery.whereKey("user", equalTo: PFUser.currentUser()!)
//        mySongsQuery.includeKey("user")
        
        
        let myLikedSongsQuery = PFQuery(className: "Song")
        myLikedSongsQuery.whereKey("objectId", matchesKey: "toSongId", inQuery: likesQuery)
        
        let query = PFQuery.orQueryWithSubqueries([mySongsQuery, myLikedSongsQuery])
        query.includeKey("user")

        
        
        query.findObjectsInBackgroundWithBlock { (songArray: [AnyObject]?, error: NSError?) -> Void in
            self.songsArray = []
            if let songList = songArray as? [Song] {
                self.songsArray += songList
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    func reload(song: Song)
    {
        let index = find(self.songsArray, song)
        self.songsArray.removeAtIndex(index!)
        
        tableView.reloadData()
    }
    
    func reloadToAddLike(song: Song)
    {
        self.viewDidAppear(true)
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
        
        if (segue.identifier == "showSocialShareOptions")
        {
            //if you're in beats
            if(segmentedController.selectedSegmentIndex == 0){
                
                var upcoming: SocialShareViewController = segue.destinationViewController as! SocialShareViewController
                
                
                let cell = self.tableView.cellForRowAtIndexPath(indexPathForSelectedMoreButton!) as! BeatsTableViewCell
                
                if let cellSongURL = cell.song!.SongFile?.url{
                    upcoming.url = NSURL(string: cellSongURL)
                }
                
                self.tableView.deselectRowAtIndexPath(indexPathForSelectedMoreButton!, animated: true)
                
                indexPathForSelectedMoreButton = nil
            }
                
                
                //if youre in freestyles
            else
            {
                
                var upcoming: SocialShareViewController = segue.destinationViewController as! SocialShareViewController
                
                
                var thisAssetURL: String  = self.stringsOfAssetURLs[indexPathForSelectedMoreButton!.row] as String
                
                if let url = NSURL(string: thisAssetURL)
                {
                    upcoming.videoURL = url
                }
                
                self.tableView.deselectRowAtIndexPath(indexPathForSelectedMoreButton!, animated: true)
                
                indexPathForSelectedMoreButton = nil
            }
            
            
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
            
            println("Gonna crash with indexPath row \(indexPath.row), total count \(self.songsArray.count)")
            let song = songsArray[indexPath.row]
            
            // cell.uploadedByUser.text = "Uploaded by " + uploadedByUserArray[indexPath.row]
            
            
            //REMEMBER HERE THAT I HAVE A DIDSET FOR CELL.SONG THAT SETS THE LIKE BUTTON TO HIDDEN/SELECTED
            cell.song = song
            
            cell.delegate = self
            
            return cell
            
        }
            
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("FreestylesTableViewCell") as! FreestylesTableViewCell
            
            // let song = myBeats[indexPath.row].objectForKey("toSong") as? Song
            cell.delegate = self
            
            cell.songTitleLabel.text = myFreestyleSongNames[indexPath.row]
            
            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            var documentsDirectory: NSString = paths[0] as! NSString
            
            var videoPath: String = documentsDirectory.stringByAppendingPathComponent(stringsOfVideoPaths[indexPath.row])
            
            var url = NSURL(fileURLWithPath: videoPath)
            
            
            var asset : AVURLAsset = AVURLAsset.assetWithURL(url) as! AVURLAsset
            
            var generator = AVAssetImageGenerator(asset: asset)
        
            
            let time = CMTimeMakeWithSeconds(1.0, 1)
            var actualTime : CMTime = CMTimeMake(0, 0)
            var error : NSError?
            let myImage = generator.copyCGImageAtTime(time, actualTime: &actualTime, error: &error)
            
            var curUIImage = UIImage(CGImage: myImage)
            
            cell.videoThumbnail.image = curUIImage ?? UIImage()
            
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(segmentedController.selectedSegmentIndex == 0) {
            return songsArray.count
        } else {
            return self.myFreestyleSongNames.count
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        //You can edit the row at indexPath if a.) You are in the myBeats section and the song is a song that you uploaded. b.) You are in the freestyles section
        
        
        if(segmentedController.selectedSegmentIndex == 0 && songsArray[indexPath.row].user == PFUser.currentUser()! )
        {
            return true
        }
        else if(segmentedController.selectedSegmentIndex == 1)
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //If the edityingStyle is a Delete Editing style, and We are in the Beats section
        //Then Query all the songs uploaded by the current user, whose objecID
        //Matches the song at the current indexPath's objectID
        // Then delete that song in background with block: reloadDataCompletionBlock
        //Then delete that song from songsArray, tell TableView to delete the row with
        //Animation, requery all the songs into SongsArray, and then reload Data
        
        if (editingStyle == UITableViewCellEditingStyle.Delete && segmentedController.selectedSegmentIndex == 0 ) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let query = PFQuery(className: "Song")
            query.whereKey("user", equalTo: PFUser.currentUser()!).whereKey("objectId", equalTo: songsArray[indexPath.row].objectId!)
            
            
            var reloadDataCompletionBlock = {(success: Bool, error: NSError?)->Void in
                self.songsArray.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.viewDidAppear(true)
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
        
        //OR if you are in the freestyles view controller, you can delete any of the rows
        //Use a query to retrieve the Video Object at this indexPath.row
        //Find object in Background with block
        //then delete object in background with block
        //In the final block, remove the video's name in the videoFreestylesName
            
        else if(editingStyle == UITableViewCellEditingStyle.Delete && segmentedController.selectedSegmentIndex == 1)
        {
            let query = PFQuery(className: "Video")
//            query.whereKey("objectId", matchesKey: videoArray[indexPath.row]["objectId"], inQuery: <#PFQuery#>)
            query.whereKey("objectId", equalTo: videoArray[indexPath.row].objectId!)
            
            
            var reloadDataCompletionBlock = {(success: Bool, error: NSError?)->Void in
                self.videoArray.removeAtIndex(indexPath.row)
                self.myFreestyleSongNames.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.viewDidAppear(true)
                self.tableView.reloadData()
            }
            
            
            var completionBlock = {(results: [AnyObject]?, error: NSError?) -> Void in
                    if let results = results as? [Video]
                    {
                        for result in results{
                            result.deleteInBackgroundWithBlock(reloadDataCompletionBlock)
                        }
                    }
            }
            
            query.findObjectsInBackgroundWithBlock(completionBlock)

        }
        
    }
}


extension BeatsAndFreestylesViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(segmentedController.selectedSegmentIndex == 0)
        {
            self.performSegueWithIdentifier("showVideoRecorderSegue", sender: self)
        }
            
        else{
            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            var documentsDirectory: NSString = paths[0] as! NSString
            
            var videoPath: String = documentsDirectory.stringByAppendingPathComponent(stringsOfVideoPaths[indexPath.row])
            
            if let url = NSURL(fileURLWithPath: videoPath) {
                if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                    
                    var newMoviePlayerViewController = MPMoviePlayerViewController(contentURL: url)
                    
                    //                    moviePlayerController = MPMoviePlayerController(contentURL: url)
                    //
                    //                    moviePlayerController.shouldAutoplay = true
                    //                    moviePlayerController.movieSourceType = MPMovieSourceType.File
                    //
                    //                    moviePlayerController.view.frame = CGRect(x: 0, y: 200, width: 500, height: 300)
                    //
                    //                    self.view.addSubview(moviePlayerController.view)
                    //
                    //                    // moviePlayerController.prepareToPlay()
                    //                    moviePlayerController.play()
                    
                    newMoviePlayerViewController.moviePlayer.fullscreen = true
                    newMoviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
                    self.presentViewController(newMoviePlayerViewController, animated: true, completion: nil)
                    
                } else {
                    println("File did not exist at \(url.path)")
                }
            } else {
                println("Could not create file URL for path \(stringsOfVideoPaths[indexPath.row])")
            }
        }
    }
}


