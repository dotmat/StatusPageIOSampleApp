//
//  StatusPageIOAPIController.swift
//  CloudFlareStatus
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: AnyObject)
}

class APIController {
    var delegate: APIControllerProtocol?
    let StatusPageIOKey: String = "" // Put the StatusPageIOKey here
    
    func getStatusPageIOSummary() {
        let baseURL = "https://\(self.StatusPageIOKey).statuspage.io/api/v2/summary.json"
        self.makeHTTPGETRequest(baseURL)
    }
    
    func getStatusPageIOIncidents() {
        let baseURL = "https://\(self.StatusPageIOKey).statuspage.io/api/v2/incidents.json"
        self.makeHTTPGETRequest(baseURL)
    }
    
    func getStatusPageIOUnresolvedIncidents() {
        let baseURL = "https://\(self.StatusPageIOKey).statuspage.io/api/v2/incidents/unresolved.json"
        self.makeHTTPGETRequest(baseURL)
    }
    
    func getStatusPageIOComponents() {
        let baseURL = "https://\(self.StatusPageIOKey).statuspage.io/api/v2/components.json"
        self.makeHTTPGETRequest(baseURL)
    }
    
    func makeHTTPGETRequest(baseURL:String) {
        let requestURL: NSURL = NSURL(string: baseURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    print(jsonData)
                    self.delegate?.didReceiveAPIResults(jsonData)
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func registerforRemoteNotificationsWithNotificationServer(registrationUrl:String, datatoPost:String, loginString: String) {
        
        let url:String = registrationUrl
        let params:NSString = datatoPost
        
        // Make credentials for Basic Auth
        let loginString:NSString = String(loginString)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        //request.addValue("application/html", forHTTPHeaderField: "Content-Type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/html", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        //print(params)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do{
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                print(jsonData)
                self.delegate?.didReceiveAPIResults(jsonData)
            }catch {
                print("Error with Json: \(error)")
            }
        }
        task.resume()
    }
    
}