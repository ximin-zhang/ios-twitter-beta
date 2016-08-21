//
//  MenuProfileCell.swift
//  Twitter
//
//  Created by ximin_zhang on 8/20/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class MenuProfileCell: UITableViewCell {

    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
