//
//  StatusPageIOUnresolvedIncidentsViewControlle.swift
//  CloudFlareStatus
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import Foundation
import UIKit

class StatusPageIOUnresolvedIncidentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    // Functions and Connections
    @IBOutlet var StatusPageIOUnresolvedIncidentsTableView : UITableView!
    
    @IBOutlet weak var NavBar: UINavigationItem!
    
    
    let api = APIController()
    var StatusPageIOUnresolvedIncidentstableData = []
    let cellIdentifier = "UnresolvedIncidentsResultsCell"
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func didReceiveAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            print(results)
            // This Page is going to get details of Status Summary API request, the API Results will get the full JSON string
            // we can then use this to work out the state of the API and Twilio.
            
            // We need to know from 'status' the 'description'
            // From components we need the value for each item and inside the item we need the description - as the title.
            
            self.NavBar.title = "Current Incidents"
            let incidentsData = results["incidents"] as! NSArray
            if incidentsData.count == 0 {
                // If we have no incidents, print to the console with no incidents and then display a pop up that says that
                print("No incidents")
                self.StatusPageIOUnresolvedIncidentsTableView.hidden = true
                self.displayAlertBox()
            }
            self.StatusPageIOUnresolvedIncidentstableData = incidentsData
            self.StatusPageIOUnresolvedIncidentsTableView.reloadData()
        })
    }
    
    func displayAlertBox(){
        let alertController = UIAlertController(title: "No Incidents!", message:
            "No incidents at this time!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return StatusPageIOUnresolvedIncidentstableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UnresolvedIncidentsResultsViewCell
        
        if let rowData: NSDictionary = self.StatusPageIOUnresolvedIncidentstableData[indexPath.row] as? NSDictionary, descriptionTitle = rowData["name"] as? String {
            
            if let componentData: NSArray = rowData["components"] as! NSArray {
                if componentData.count > 0 {
                    let componentDictionary: NSDictionary = componentData[0] as! NSDictionary
                    if let componentDescription: String = componentDictionary["name"] as? String {
                        cell.IncidentComponentsEffectedLabel?.text = "Effects: \(componentDescription)"
                    }
                    else
                    {
                        cell.IncidentComponentsEffectedLabel?.text = ""
                    }
                }
                else
                {
                    cell.IncidentComponentsEffectedLabel?.text = ""
                }
            }
            
            let incidentUpdates: NSArray = rowData["incident_updates"] as! NSArray
            let latestUpdate: NSDictionary = incidentUpdates[0] as! NSDictionary
            let latestUpdateBody: String = latestUpdate["body"] as! String
            
            cell.IncidentName?.text = descriptionTitle
            cell.IncidentStatus?.text = "Current Status: \(rowData["status"] as! String)"
            cell.UpdatedAtTimestampLabel?.text = "Last Update: \(rowData["updated_at"] as! String)"
            cell.LatestInformationLabel?.text = "Latest: \(latestUpdateBody)"
            
        }
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        self.NavBar.title = "Refreshing Data..."
        api.getStatusPageIOUnresolvedIncidents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

