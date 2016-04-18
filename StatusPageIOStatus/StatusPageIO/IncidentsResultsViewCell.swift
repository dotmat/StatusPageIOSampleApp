//
//  IncidentsResultsViewCell.swift
//  TwilioStatus
//
//  Created by Mathew Jenkinson on 22/01/2016.
//  Copyright © 2016 Chicken and Bee. All rights reserved.
//

import UIKit
import Foundation

class IncidentsResultsViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var IncidentName: UILabel!
    @IBOutlet weak var IncidentStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
