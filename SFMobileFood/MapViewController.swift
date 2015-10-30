//
//  MapViewController.swift
//  SODASample
//
//  Created by Frank A. Krueger on 8/10/14.
//  Copyright (c) 2014 Socrata, Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManger:CLLocationManager = CLLocationManager()
    
    var data: [[String: AnyObject]]! = []
    
    var currentItem: HCMFDataInfo = HCMFDataInfo(item: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Enable user location tracking
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.NotDetermined || authstate == CLAuthorizationStatus.Denied){
            locationManger.requestWhenInUseAuthorization()
        }
        //Update data
        updateWithData(data, animated: false)
    }
    
    func updateWithData(data: [[String: AnyObject]]!, animated: Bool) {
        
        // Remember the data because we may not be able to display it yet
        self.data = data
        
        if (!isViewLoaded()) {
            return
        }
        
        // Clear old annotations
        if mapView.annotations.count > 0 {
            let ex = mapView.annotations
            mapView.removeAnnotations(ex)
        }
        
        // Longitude and latitude accumulators so we can find the center
        var lata : CLLocationDegrees = 0.0
        var lona : CLLocationDegrees = 0.0
        
        // Create annotations for the data
        var annotationsArray : [HCMFCustomAnnotation] = []
        for item in data {
            let cellData = HCMFDataInfo(item: item) as HCMFDataInfo
            if cellData.hasLocation() {
                let lat = cellData.lat
                let lon = cellData.lon
                lata += lat
                lona += lon
                let newAnnotation = HCMFCustomAnnotation(title: cellData.fullName, subtitle: cellData.foodType, coordinate: CLLocationCoordinate2D (latitude: lat, longitude: lon), itemData: item)
                annotationsArray.append(newAnnotation)
            }
        }
        
        // Set the annotations and center the map
        if (annotationsArray.count > 0) {
            //Add annotations to map
            mapView.addAnnotations(annotationsArray)
            /*
            if let currentLocation = locationManger.location {
                //Center if there's user location
                let r = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 2000, 2000)
                mapView.setRegion(r, animated: animated)
            } else {
                //Center in the middle of annotations if there's no user location
            */
                let w = 1.0 / Double(annotationsArray.count)
                let r = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lata*w, longitude: lona*w), 2000, 2000)
                mapView.setRegion(r, animated: animated)
            //}
        }
    }
    
    //Change the map delegate to have a custom view
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    //Call if the pin is pressed
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! HCMFCustomAnnotation
            let item: [String: AnyObject] = location.itemData
            currentItem = HCMFDataInfo(item: item)
            performSegueWithIdentifier("OpenCartDetailsFromMap", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenCartDetailsFromMap") {
            var destinationViewController = segue.destinationViewController as! HCMFDetailViewViewController
            destinationViewController.currentItem = currentItem
            
        }
    }
    
    
}

