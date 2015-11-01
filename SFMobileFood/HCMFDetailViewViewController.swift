//
//  HCMFDetailViewViewController.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 27/09/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit
import MapKit

class HCMFDetailViewViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var DetailsMapView: MKMapView!
    
    @IBOutlet weak var cartName: UILabel!
    
    @IBOutlet weak var cartFood: UITextView!
    
    @IBOutlet weak var cartAddress: UILabel!
    
    @IBOutlet weak var generalScrollView: UIScrollView!
    
    @IBOutlet weak var cartType: UILabel!
    
    @IBOutlet weak var cartOpenSchedule: UITextView!
    
    var currentItem: HCMFDataInfo = HCMFDataInfo(item: [:])
    var currentParams: HCMFGeneralParams = HCMFGeneralParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWithData(currentItem, animated: false)
    }
    
    @IBAction func openTermsOfUse(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://hacemoscontactos.com/sf-mobile-food-terms-of-use/")!)
    }
    

    
    func updateWithData(currentItem: HCMFDataInfo, animated: Bool) {
        
        // Remember the data because we may not be able to display it yet
        self.currentItem = currentItem
        
        if (!isViewLoaded()) {
            return
        }
        
        cartName.text = currentItem.fullName
        // disable scroll to force growth
        cartFood.scrollEnabled = false
        cartFood.text = currentItem.foodType
        cartOpenSchedule.scrollEnabled = false
        cartOpenSchedule.text = currentItem.schedule
        cartAddress.text = currentItem.street
        cartType.text = currentItem.facilityType

        // Create annotations for the data
        var anns : [MKAnnotation] = []
        var lat : CLLocationDegrees = 0.0
        var lon : CLLocationDegrees = 0.0
        
        if currentItem.hasLocation() {
            lat = currentItem.lat
            lon = currentItem.lon
            let a = MKPointAnnotation()
            a.coordinate = CLLocationCoordinate2D (latitude: lat, longitude: lon)
            anns.append(a)
        }
        
        // Set the annotations and center the map
        
        if (anns.count > 0) {
            DetailsMapView.addAnnotations(anns)
            let w = 1.0 / Double(anns.count)
            let r = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lat*w, longitude: lon*w), 2000, 2000)
            DetailsMapView.setRegion(r, animated: animated)
        } else {
            let alert = UIAlertView(title: "No location", message: "This mobile food facility has no location info available, please see address.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
