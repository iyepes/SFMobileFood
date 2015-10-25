//
//  QueryViewController.swift
//  SODASample
//
//  Created by Frank A. Krueger on 8/10/14.
//  Copyright (c) 2014 Socrata, Inc. All rights reserved.
//

import UIKit

class QueryViewController: UITableViewController {
    
    //Open Data URL and Registered access tokens in: http://dev.socrata.com/register
    let client = SODAClient(domain: "data.sfgov.org", token: "doOsHAaYFknfIi8v6gxUHVEzw")
    
    let cellId = "DetailCell"
    
    var data: [[String: AnyObject]]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a pull-to-refresh control
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Auto-refresh
        refresh(self)
    }
    
    /// Asynchronous performs the data query then updates the UI
    func refresh (sender: AnyObject!) {
        
        //let cngQuery = client.queryDataset("3k2p-39jp").filter("within_circle(incident_location, 47.59815, -122.334540, 500) AND event_clearance_group IS NOT NULL")
        
        //https://data.sfgov.org/resource/rqzj-sfat.json
        
        let cngQuery = client.queryDataset("rqzj-sfat").filter("status = 'APPROVED'")
        
        //cngQuery.orderAscending("expirationdate").get { res in
        
        cngQuery.orderAscending("applicant").get { res in
            switch res {
            case .Dataset (let data):
                // Update our data
                self.data = data
            case .Error (let err):
                let alert = UIAlertView(title: "Error Refreshing", message: err.userInfo.debugDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
            // Update the UI
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            self.updateMap(animated: true)
        }
    }
    
    /// Finds the map controller and updates its data
    private func updateMap(animated animated: Bool) {
        if let tabs = (self.parentViewController?.parentViewController as? UITabBarController) {
            if let mapNav = tabs.viewControllers![1] as? UINavigationController {
                if let map = mapNav.viewControllers[0] as? MapViewController {
                    map.updateWithData (data, animated: animated)
                }
            }
        }
    }
    
    override func tableView(tableView: (UITableView!), didSelectRowAtIndexPath indexPath: (NSIndexPath!)) {
        // Show the map
        if let tabs = (self.parentViewController?.parentViewController as? UITabBarController) {
            tabs.selectedIndex = 1
        }
    }
    
    override func tableView(tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let c = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCMFCartTableViewCell!
        
        let item = data[indexPath.row]
        
        let name = item["applicant"]! as! String
        let placeId = item["objectid"]! as! String
        
        let fullName = name
        let foodType = item["fooditems"]! as! String
        let street = item["address"]! as! String
        
        c.cartName?.text = fullName
        c.cartFood?.text = foodType
        //let city = "San Francisco"
        //let state = "CA"
        //c.detailTextLabel?.text = "\(street), \(city), \(state)"
        c.cartAddress?.text = street
        
        return c
    }
}
