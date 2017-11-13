//
//  SideBarMenuTVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/19/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class SideBarMenuTVC: UITableViewCell {

    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMenu.tintColor = UIColor.whiteColor()
        lblMenu.textColor = UIColor.whiteColor()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
