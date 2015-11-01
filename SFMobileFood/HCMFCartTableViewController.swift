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
    
    @IBOutlet weak var loadingDataMessage: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    
 
    var currentItem: HCMFDataInfo = HCMFDataInfo(item: [:])
    let currentParams: HCMFGeneralParams = HCMFGeneralParams()
    var listItems: HCMFListItems = HCMFListItems()
    var collapsedStatus: [Bool] = []

    //Open Data URL and Registered access tokens http://dev.socrata.com/register
    //San Francisco Mobile Food Facility Permit
    //https://data.sfgov.org/resource/rqzj-sfat.json
    let client = SODAClient(domain: "data.sfgov.org", token: "doOsHAaYFknfIi8v6gxUHVEzw")
    let dataSetName = "rqzj-sfat"
    let dataFilter = "status = 'APPROVED'"
    let orderedBy = "applicant"
    
    
    //Cell reusable ID
    let cellId = "DetailCell"
    let headerCellId = "HeaderCell"
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
        //Suscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Data source update
    
    /// Performs the full query then updates the UI
    func refresh (sender: AnyObject!) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let cngQuery = client.queryDataset(dataSetName).filter(dataFilter)
        cngQuery.orderAscending(orderedBy).get { res in
            switch res {
            case .Dataset (let data):
                // Update our data
                self.data = data
                self.listItems = self.updateListItems(data)
                self.collapsedStatus = self.initCollapseStatus(self.listItems.sections.count)
                self.loadingDataMessage.hidden = true
                self.loadingActivityIndicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Error (let err):
                // for debugging err.userInfo.description or err.userInfo.debugDescription
                let alert = UIAlertView(title: "No data available", message: "Please verify your internet connection, try again later pressing the search button.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.loadingDataMessage.hidden = true
                self.loadingActivityIndicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            // Update the UI
            self.tableView.reloadData()
            self.searchButton.hidden = false
            self.searchTextField.hidden = false
            self.updateMap(animated: true)
        }
        refreshControl.endRefreshing()
    }
    
    /// Performs the search query then updates the UI
    func refreshSearch (sender: AnyObject!, searchTerm : String) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let cngQuery = client.queryDataset(dataSetName).filter(dataFilter).fullText(searchTerm)
        cngQuery.orderAscending(orderedBy).get { res in
            switch res {
            case .Dataset (let data):
                // Update our data
                self.data = data
                self.listItems = self.updateListItems(data)
                self.collapsedStatus = self.initCollapseStatus(self.listItems.sections.count)
                self.loadingActivityIndicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Error (let err):
                // for debugging err.userInfo.description or err.userInfo.debugDescription
                let alert = UIAlertView(title: "No data available", message: "Please verify your internet connection, try again later pressing the search button.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.loadingActivityIndicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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

    //MARK: - Search actions
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        searchView.endEditing(true)
        self.loadingActivityIndicator.startAnimating()
        refreshSearch(self.tableView, searchTerm: searchTextField.text!)
    }

    @IBAction func searchViewTapped(sender: AnyObject) {
        searchView.endEditing(true)
    }
    
    //MARK: - Cell actions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchView.endEditing(true)
        //currentItem = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        currentItem = HCMFDataInfo(item: listItems.items[indexPath.section][indexPath.row]) as HCMFDataInfo
        performSegueWithIdentifier("OpenCartDetails", sender: self)
    }
    
    func headerExpandTapped(sender: UIButton!)
    {
        let sectionNumber: Int = sender.tag
        self.collapsedStatus[sectionNumber] = !self.collapsedStatus[sectionNumber]
        self.tableView.reloadData()
    }
    

    //MARK: - Number of elements
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listItems.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data.count
        if !collapsedStatus[section] {
            return listItems.items[section].count
        } else {
            return 0
        }
    }
    
    //MARK: - Cell creation
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(headerCellId) as! HCMFHeaderTableViewCell!
        cell.cartName.text = listItems.sections[section][0]
        cell.cartFood.text = listItems.sections[section][1]
        cell.expandButton.tag = section
        cell.expandButton.selected = !collapsedStatus[section]
        cell.expandButton.addTarget(self, action: "headerExpandTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! HCMFCartTableViewCell!
        //let cellData = HCMFDataInfo(item: data[indexPath.row]) as HCMFDataInfo
        let cellData = HCMFDataInfo(item: listItems.items[indexPath.section][indexPath.row]) as HCMFDataInfo
        //c.cartName.text = cellData.fullName
        //c.cartFood.text = cellData.foodType
        cell.cartAddress.text = cellData.street
        return cell
    }
    
    //MARK: - Keyboard Management Methods
    
    //Registering for notifications
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
    
    //reload data when search field is cleared
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.refresh(self)
        return true
    }
    
    // MARK: - Data preparation for display
    
    // Prepare data to be shown in sections
    func updateListItems (data: [[String: AnyObject]]!) -> HCMFListItems {
        let listItems: HCMFListItems = HCMFListItems()
        
        if data.count > 0 {
            var currentName: String = ""
            var sectionHeader:[String] = []
            var sectionData: [[String: AnyObject]] = []
            for item in data {
                let itemData = HCMFDataInfo(item: item) as HCMFDataInfo
                if (itemData.fullName == currentName){
                    sectionData = sectionData + [item]
                } else if (currentName == "") {
                    currentName = itemData.fullName
                    sectionHeader = [itemData.fullName , itemData.foodType]
                    sectionData = [item]
                } else {
                    currentName = itemData.fullName
                    listItems.addSection(sectionHeader, item: sectionData)
                    sectionHeader = [itemData.fullName , itemData.foodType]
                    sectionData = [item]
                }
            }
            listItems.addSection(sectionHeader, item: sectionData)
        }
        return listItems
    }
    
    func initCollapseStatus(numberOfSections: Int) -> [Bool]{
        var collapsedStatus: [Bool] = []
        for var index = 0; index < numberOfSections; ++index {
            collapsedStatus = collapsedStatus + [true]
        }
        return collapsedStatus
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenCartDetails") {
            var destinationViewController = segue.destinationViewController as! HCMFDetailViewViewController
            destinationViewController.currentItem = currentItem
            
        }
    }

}
