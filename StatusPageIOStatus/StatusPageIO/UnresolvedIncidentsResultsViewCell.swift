//
//  UnresolvedIncidentsResultsViewCell.swift
//  TwilioStatus
//
//  Created by Mathew Jenkinson on 22/01/2016.
//  Copyright © 2016 Chicken and Bee. All rights reserved.
//

import UIKit
import Foundation

class UnresolvedIncidentsResultsViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var IncidentName: UILabel!
    @IBOutlet weak var IncidentStatus: UILabel!
    @IBOutlet weak var IncidentComponentsEffectedLabel: UILabel!
    @IBOutlet weak var UpdatedAtTimestampLabel: UILabel!
    @IBOutlet weak var LatestInformationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}