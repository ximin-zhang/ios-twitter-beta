//
//  ProfileCell.swift
//  Twitter
//
//  Created by ximin_zhang on 8/19/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var followersCountLabel: UILabel!

    @IBOutlet weak var profileBackgroundImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var screennameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
