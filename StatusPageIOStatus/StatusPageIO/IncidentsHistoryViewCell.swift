//
//  IncidentsHistoryViewCell.swift
//  TwilioStatus
//
//  Created by Mathew Jenkinson on 11/02/2016.
//  Copyright © 2016 Chicken and Bee. All rights reserved.
//

import Foundation
import UIKit

class IncidentsHistoryResultsViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var IncidentStatusLabel: UILabel!
    @IBOutlet weak var IncidentStatusBodyLabel: UILabel!
    @IBOutlet weak var IncidentStatusTimestampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}