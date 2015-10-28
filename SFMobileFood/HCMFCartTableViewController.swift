//
//  HCMFCartTableViewController.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 27/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit

class HCMFCartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    
 
    var currentItem: HCMFDataInfo = HCMFDataInfo(item: [:])
    let currentParams: HCMFGeneralParams = HCMFGeneralParams()

    //Open Data URL and Registered access tokens in: http://dev.socrata.com/register
    let client = SODAClient(domain: "data.sfgov.org", token: "doOsHAaYFknfIi8v6gxUHVEzw")
    let dataSetName = "rqzj-sfat"
    let dataFilter = "status = 'APPROVED'"
    let orderedBy = "applicant"
    
    
    //Cell reusable ID
    let cellId = "DetailCell"
    //Data collector
    var data: [[String: AnyObject]]! = []
    //Animating refresh indicator for table view
    let refreshControl = UIRefreshControl ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        tableView.backgroundColor = currentParams.backgroundColor
        self.registerForKeyboardNotifications()
        
        // Create a pull-to-refresh control
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        loadingActivityIndicator.startAnimating()
        searchButton.hidden = true
        searchTextField.hidden = true
        // Auto-refresh
        refresh(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// Asynchronous performs the data query then updates the UI
    func refresh (sender: AnyObject!) {
        
        //San Francisco Mobile Food Facility Permit
        //https://data.sfgov.org/resource/rqzj-sfat.json
        
        let cngQuery = client.queryDataset(dataSetName).filter(dataFilter)
        cngQuery.orderAscending(orderedBy).get { res in
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
            self.tableView.reloadData()
            self.searchButton.hidden = false
            self.searchTextField.hidden = false
            self.updateMap(animated: true)
        }
        refreshControl.endRefreshing()
    }
    
    /// Asynchronous performs the data query then updates the UI
    func refreshSearch (sender: AnyObject!, searchTerm : String) {
        
        //San Francisco Mobile Food Facility Permit
        //https://data.sfgov.org/resource/rqzj-sfat.json
        
        let cngQuery = client.queryDataset(dataSetName).filter(dataFilter).fullText(searchTerm)
        cngQuery.orderAscending(orderedBy).get { res in
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

    @IBAction func searchButtonPressed(sender: AnyObject) {
        searchView.endEditing(true)
        self.loadingActivityIndicator.startAnimating()
        refreshSearch(self.tableView, searchTerm: searchTextField.text!)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* //Show the map
        if let tabs = (self.parentViewController?.parentViewController as? UITabBarController) {
        tabs.selectedIndex = 1
        }
        */
        searchView.endEditing(true)
        currentItem = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        performSegueWithIdentifier("OpenCartDetails", sender: self)
    }
    
    //func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let c = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCMFCartTableViewCell!
        let cellData = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        c.cartName.text = cellData.fullName
        c.cartFood.text = cellData.foodType
        c.cartAddress.text = cellData.street
        return c
    }
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        
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
