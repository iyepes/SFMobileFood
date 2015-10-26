//
//  QueryViewController.swift
//  SODASample
//
//  Created by Frank A. Krueger on 8/10/14.
//  Copyright (c) 2014 Socrata, Inc. All rights reserved.
//

import UIKit

class QueryViewController: UITableViewController {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var upperView: UIView!
    
    //Open Data URL and Registered access tokens in: http://dev.socrata.com/register
    let client = SODAClient(domain: "data.sfgov.org", token: "doOsHAaYFknfIi8v6gxUHVEzw")
    
    let cellId = "DetailCell"
    
    var data: [[String: AnyObject]]! = []
    
    var currentItem: HCMFDataInfo = HCMFDataInfo(item: [:])
    
    var currentParams: HCMFGeneralParams = HCMFGeneralParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = currentParams.backgroundColor
        
        // Create a pull-to-refresh control
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        loadingActivityIndicator.startAnimating()
        // Auto-refresh
        refresh(self)
    }
    
    /// Asynchronous performs the data query then updates the UI
    func refresh (sender: AnyObject!) {
        
        //let cngQuery = client.queryDataset("3k2p-39jp").filter("within_circle(incident_location, 47.59815, -122.334540, 500) AND event_clearance_group IS NOT NULL")
        
        //https://data.sfgov.org/resource/rqzj-sfat.json
        
        let cngQuery = client.queryDataset("rqzj-sfat").filter("status = 'APPROVED'")
        
        cngQuery.orderAscending("applicant").get { res in
            switch res {
            case .Dataset (let data):
                // Update our data
                self.data = data
                self.loadingActivityIndicator.stopAnimating()
            case .Error (let err):
                let alert = UIAlertView(title: "Error Refreshing", message: err.userInfo.debugDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.loadingActivityIndicator.stopAnimating()
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
        /* //Show the map
        if let tabs = (self.parentViewController?.parentViewController as? UITabBarController) {
            tabs.selectedIndex = 1
        }
        */
        currentItem = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        performSegueWithIdentifier("OpenCartDetails", sender: self)
    }
    
    
    override func tableView(tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let c = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCMFCartTableViewCell!
        
        let cellData = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        c.cartName.text = cellData.fullName
        c.cartFood.text = cellData.foodType
        c.cartAddress.text = cellData.street
        return c
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenCartDetails") {
            var destinationViewController = segue.destinationViewController as! HCMFDetailViewViewController
            destinationViewController.currentItem = currentItem
            
        }
    }
    
}
