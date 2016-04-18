//
//  ViewController.swift
//  StatusPageIOSummaryViewController
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import UIKit

class StatusPageIOSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    // Functions and Connections
    @IBOutlet var StatusPageIOSummaryTableView : UITableView!
    @IBOutlet weak var NavigationBarBody: UINavigationBar!
    @IBOutlet weak var NavigationBarTitle: UINavigationItem!
    
    let api = APIController()
    var StatusPageIOSummarytableData = []
    let cellIdentifier = "SummaryResultsCell"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func didReceiveAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            print(results)
            // This Page is going to get details of Status Summary API request, the API Results will get the full JSON string
            // we can then use this to work out the state of the API and Twilio.
            
            // We need to know from 'status' the 'description'
            // From components we need the value for each item and inside the item we need the description - as the title.
            
            self.refreshControl.endRefreshing()
            
            let operationalStatus = results["status"] as! NSDictionary
            let operationalDescription: String = operationalStatus["description"] as! String
            
            let operationalComponents = results["components"] as! NSArray
            
            self.StatusPageIOSummarytableData = operationalComponents
            self.StatusPageIOSummaryTableView.reloadData()
            self.NavigationBarTitle.title = operationalDescription
            if (operationalDescription == "All Systems Operational") {
                self.NavigationBarBody.barTintColor = self.UIColorFromRGB(0x2F9A41)
            }
            if (operationalDescription == "Partially Degraded Service") {
                self.NavigationBarBody.barTintColor = self.UIColorFromRGB(0xffb00b)
            }
            if (operationalDescription == "Minor Service Outage") {
                self.NavigationBarBody.barTintColor = self.UIColorFromRGB(0xFFB00B)
            }
            
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.NavigationBarTitle.title = "Refreshing Data..."
        api.getStatusPageIOSummary()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return StatusPageIOSummarytableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SummaryResultsViewCell
        
        if let rowData: NSDictionary = self.StatusPageIOSummarytableData[indexPath.row] as? NSDictionary,
            descriptionTitle = rowData["name"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.ComponentName?.text = descriptionTitle
                //cell.ComponentStatus?.text = rowData["status"] as? String
                if(rowData["status"] as? String == "operational"){
                    cell.ComponentStatus?.text = "Operational"
                    cell.statusImageView?.image = UIImage(named: "GreenTickIcon1")
                }
                if(rowData["status"] as? String == "degraded_performance"){
                    cell.ComponentStatus?.text = "Degreaded Performance"
                    cell.statusImageView?.image = UIImage(named: "Amber!Icon")
                }
                if(rowData["status"] as? String == "partial_outage"){
                    cell.ComponentStatus?.text = "Partial Outage"
                    cell.statusImageView?.image = UIImage(named: "AmberXIcon")
                }
                if(rowData["status"] as? String == "major_outage"){
                    cell.ComponentStatus?.text = "Major Outage"
                    cell.statusImageView?.image = UIImage(named: "RedXIcon")
                }
        }
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.StatusPageIOSummaryTableView.addSubview(self.refreshControl)
        api.delegate = self
        api.getStatusPageIOSummary()
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}