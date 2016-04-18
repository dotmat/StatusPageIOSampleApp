//
//  SummaryResultsViewCell.swift
//  TwilioStatus
//
//  Created by Mathew Jenkinson on 21/01/2016.
//  Copyright © 2016 Chicken and Bee. All rights reserved.
//
import UIKit
import Foundation

class SummaryResultsViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var ComponentName: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var ComponentStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}