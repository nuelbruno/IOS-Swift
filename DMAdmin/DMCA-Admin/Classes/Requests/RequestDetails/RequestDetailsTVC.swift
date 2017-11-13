//
//  RequestTVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/16/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit


class RequestDetailsTVC: UITableViewCell {
    
    @IBOutlet weak var vccHeightConstraint98: NSLayoutConstraint!
    @IBOutlet weak var vccHeightConstraint95: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewContentContainer: UIView!
    @IBOutlet weak var viewDetailsContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }     
    
}
