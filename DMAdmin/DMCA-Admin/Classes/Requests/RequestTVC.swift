//
//  RequestTVC.swift
//  DMCA-Admin
//
//  Created by Niraj Kumar on 5/16/16.
//  Copyright © 2016 Niraj Kumar. All rights reserved.
//

import UIKit

class RequestTVC: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblRequestReference: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    
    @IBOutlet weak var vdHeightConstraints: NSLayoutConstraint!    
    @IBOutlet weak var vdsHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var viewDetailsContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
