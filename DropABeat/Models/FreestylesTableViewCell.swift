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
    
    
    
    @IBOutlet weak var videoThumbnail: UIImageView!
   
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
