//
//  FreestylesTableViewCell.swift
//  DropABeat
//
//  Created by Alex Raman on 7/29/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit

class FreestylesTableViewCell: UITableViewCell {

    var pathString: String?
    
    var delegate: presentShareActionSheetDelegate!
    
    @IBOutlet weak var videoThumbnail: UIImageView!
   
    @IBOutlet weak var songTitleLabel: UILabel!
    
    
    
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        //An Action Sheet that lets you choose to report/share a song
        var myActionSheet: UIAlertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let shareButtonAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            println("Share button tapped")
            
        }
        
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (ACTION) -> Void in
            println("Cancel button tapped")
            
        }
        
        myActionSheet.addAction(shareButtonAction)
        myActionSheet.addAction(cancelButtonAction)
        
        delegate.presentActionSheet(myActionSheet)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol presentShareActionSheetDelegate
{
    func presentActionSheet(actionSheet: UIAlertController) -> Void
}

