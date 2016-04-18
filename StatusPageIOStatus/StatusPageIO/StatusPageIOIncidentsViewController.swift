//
//  StatusPageIOIncidentsViewController.swift
//  CloudFlareStatus
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import Foundation
import UIKit

class StatusPageIOIncidentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    // Functions and Connections
    @IBOutlet var StatusPageIOIncidentsTableView : UITableView!
    @IBOutlet weak var NavBarTitle: UINavigationItem!
    
    let api = APIController()
    var StatusPageIOIncidentstableData = []
    let cellIdentifier = "IncidentsResultsCell"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    func didReceiveAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            print(results)
            // This Page is going to get details of Status Summary API request, the API Results will get the full JSON string
            // we can then use this to work out the state of the API and Twilio.
            
            // We need to know from 'status' the 'description'
            // From components we need the value for each item and inside the item we need the description - as the title.
            
            self.refreshControl.endRefreshing()
            
            let incidentsDataUpdatedDatePage = results["page"] as! NSDictionary
            let incidentsDataUpdatedTimetamp = incidentsDataUpdatedDatePage["updated_at"] as! String
            
            let incidentsData = results["incidents"] as! NSArray
            self.StatusPageIOIncidentstableData = incidentsData
            self.StatusPageIOIncidentsTableView.reloadData()
            self.NavBarTitle.title = "Showing last: \(incidentsData.count) incidents"
            
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.NavBarTitle.title = "Refreshing Data..."
        api.getStatusPageIOIncidents()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return StatusPageIOIncidentstableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! IncidentsResultsViewCell
        
        if let rowData: NSDictionary = self.StatusPageIOIncidentstableData[indexPath.row] as? NSDictionary, descriptionTitle = rowData["name"] as? String {
            cell.IncidentName?.text = descriptionTitle
            if(rowData["status"] as? String == "investigating"){
                cell.IncidentStatus?.text = "Investigating"
            }
            if(rowData["status"] as? String == "identified"){
                cell.IncidentStatus?.text = "Identified"
            }
            if(rowData["status"] as? String == "monitoring"){
                cell.IncidentStatus?.text = "Monitoring"
            }
            if(rowData["status"] as? String == "resolved"){
                cell.IncidentStatus?.text = "Resolved"
            }
            if(rowData["status"] as? String == "postmortem"){
                cell.IncidentStatus?.text = "Postmortem"
            }
            
            // If the impact of the cell is something we want to change the cell color to something to help highlight the severity of the issue.
            //if(rowData["impact"] as? String == "none"){
            // Do nothing
            //   }
            //if(rowData["impact"] as? String == "minor"){
            //       cell.backgroundColor = UIColor.yellowColor()
            //   }
            //if(rowData["impact"] as? String == "major"){
            //        cell.backgroundColor = UIColor.orangeColor()
            //    }
            //if(rowData["impact"] as? String == "critical"){
            //        cell.backgroundColor = UIColor.redColor()
            //    }
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowStatusPageIOIncidentsHistoryDetail" {
            // If we are passing data into our Incidents History controller we can also pass the details into the dictionary too.
            print(self.StatusPageIOIncidentstableData[StatusPageIOIncidentsTableView!.indexPathForSelectedRow!.row])
            var incidentHistoryArray = self.StatusPageIOIncidentstableData[StatusPageIOIncidentsTableView!.indexPathForSelectedRow!.row]
            
            
            let statusPageIOIncidentsHistoryViewController = (segue.destinationViewController as! StatusPageIOIncidentsHistoryViewController)
            
            statusPageIOIncidentsHistoryViewController.incidentName = incidentHistoryArray["name"] as! String
            statusPageIOIncidentsHistoryViewController.incidentstatus = "Status: \(incidentHistoryArray["status"] as! String)"
            statusPageIOIncidentsHistoryViewController.incidentCreatedTimestamp = "Created at: \(incidentHistoryArray["created_at"] as! String)"
            statusPageIOIncidentsHistoryViewController.IncidentLastUpdateTimestamp = "Last Update: \(incidentHistoryArray["updated_at"] as! String)"
            // Not all incidents are monitored so if the value is blank we just report this incident nothing.
            if let incidentHistoryMonitoringTimestamp = incidentHistoryArray["monitoring_at"] as? String {
                statusPageIOIncidentsHistoryViewController.incidentMonitoringTimestamp = "Monitoring from: \(incidentHistoryMonitoringTimestamp)"
            }
            else {
                statusPageIOIncidentsHistoryViewController.incidentMonitoringTimestamp = ""
            }
            // If the incident is not resolved we cant publish a resolved at date.
            if let incidentHistoryResolvedTimestamp = incidentHistoryArray["resolved_at"] as? String {
                statusPageIOIncidentsHistoryViewController.incidentResolvedTimestamp = "Reported Resolved: \(incidentHistoryArray["resolved_at"] as! String)"
            } else {
                statusPageIOIncidentsHistoryViewController.incidentResolvedTimestamp = ""
            }
            
            statusPageIOIncidentsHistoryViewController.incidentHistoryImpact = "Impact: \(incidentHistoryArray["impact"] as! String)"
            statusPageIOIncidentsHistoryViewController.StatusPageIOIncidentsHistoryTableData = incidentHistoryArray["incident_updates"] as! NSArray
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.NavBarTitle.title = "Refreshing Data..."
        api.getStatusPageIOIncidents()
        // Clear the APNS badge from the users home screen.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.StatusPageIOIncidentsTableView.addSubview(self.refreshControl)
        api.delegate = self
        api.getStatusPageIOIncidents()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}