//
//  HCMFCustomAnnotation.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 28/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import Foundation
import MapKit

class HCMFCustomAnnotation: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    var itemData: [String: AnyObject] = [:]
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, itemData: [String: AnyObject]) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.itemData = itemData
        
        super.init()
    }
    
    
}
