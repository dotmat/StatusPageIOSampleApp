//
//  EndPointsViewCell.swift
//  TwilioStatus
//
//  Created by Mathew Jenkinson on 28/01/2016.
//  Copyright © 2016 Chicken and Bee. All rights reserved.
//

import UIKit
import Foundation

class EndPointsViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var EndPointName: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var EndPointStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}