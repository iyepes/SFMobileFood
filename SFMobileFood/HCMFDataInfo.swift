//
//  HCMFDataInfo.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 25/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import Foundation

class HCMFDataInfo: NSObject {

    var item: [String: AnyObject] = [:]
    
    /// Initializes with SODA data
    init(item: [String: AnyObject]) {
        self.item = item
    }
    
    var fullName: String {
        if let applicant = item["applicant"] {
            return applicant as! String
        } else {
            return "N/A"
        }
    }
    
    var placeId: String {
        if let objectid = item["objectid"] {
            return objectid as! String
        } else {
            return "N/A"
        }
    }
    
    var foodType: String {
        if let fooditems = item["fooditems"] {
            return fooditems as! String
        } else {
            return "Food description not available"
        }
    }

    var schedule: String {
        if let schedule = item["dayshours"] {
            return schedule as! String
        } else {
            return "Schedule not available"
        }
    }
    
    var street: String {
        if let address = item["address"] {
            //let city = "San Francisco"
            //let state = "CA"
            //c.detailTextLabel?.text = "\(street), \(city), \(state)"
            return address as! String
        } else {
            return "Address not available"
        }
    }

    
    var facilityType: String {
        if let facilityType = item["facilitytype"] {
            return facilityType as! String
        } else {
            return "Type not available"
        }
    }
    
    var lat: Double {
        if self.hasLocation() {
            return (item["latitude"]! as! NSString).doubleValue
        } else {
            return 0
        }
    
    }
    
    var lon: Double {
        if self.hasLocation() {
            return (item["longitude"]! as! NSString).doubleValue
        } else {
            return 0
        }
        
    }
    
    func hasLocation() -> Bool {
        if let loc: AnyObject = item["location"] {
            return true
        } else {
            return false
        }
    
    }

}
