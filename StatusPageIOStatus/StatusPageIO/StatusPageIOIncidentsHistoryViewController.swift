//
//  StatusPageIOIncidentsHistoryViewController.swift
//  CloudFlareStatus
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import Foundation
import UIKit


class StatusPageIOIncidentsHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Functions and Connections
    @IBAction func CloseIncidentHistoryButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBOutlet weak var IncidentNameLabel: UILabel!
    @IBOutlet weak var IncidentStatusLabel: UILabel!
    @IBOutlet weak var IncidentCreatedTimestampLabel: UILabel!
    @IBOutlet weak var IncidentLastUpdateTimestampLabel: UILabel!
    @IBOutlet weak var IncidentMonitoringTimestampLabel: UILabel!
    @IBOutlet weak var IncidentResolvedTimestampLabel: UILabel!
    @IBOutlet weak var IncidentHistoryImpactLabel: UILabel!
    @IBOutlet weak var IncidentsHistoryTableView: UITableView!
    
    var StatusPageIOIncidentsHistoryTableData = []
    let cellIdentifier = "IncidentsHistoryResultsCell"
    
    // Declaring variables we can pass data to in the segue
    var incidentName: String = ""
    var incidentstatus: String = ""
    var incidentCreatedTimestamp: String = ""
    var IncidentLastUpdateTimestamp: String = ""
    var incidentMonitoringTimestamp: String = ""
    var incidentResolvedTimestamp: String = ""
    var incidentHistoryImpact: String = ""
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return StatusPageIOIncidentsHistoryTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! IncidentsHistoryResultsViewCell
        
        if let rowData: NSDictionary = self.StatusPageIOIncidentsHistoryTableData[indexPath.row] as? NSDictionary, incidentUpdatesBody = rowData["body"] as? String {
            cell.IncidentStatusBodyLabel?.text = incidentUpdatesBody
            cell.IncidentStatusLabel?.text = rowData["status"] as? String
            cell.IncidentStatusTimestampLabel?.text = rowData["updated_at"] as? String
            
        }
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        IncidentNameLabel.text = incidentName
        IncidentStatusLabel.text = incidentstatus
        IncidentCreatedTimestampLabel.text = incidentCreatedTimestamp
        IncidentLastUpdateTimestampLabel.text = IncidentLastUpdateTimestamp
        IncidentMonitoringTimestampLabel.text = incidentMonitoringTimestamp
        IncidentResolvedTimestampLabel.text = incidentResolvedTimestamp
        IncidentHistoryImpactLabel.text = incidentHistoryImpact
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
