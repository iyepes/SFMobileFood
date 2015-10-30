//
//  HCMFListItems.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 30/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit

class HCMFListItems: NSObject {

    var sections:[[String]] = []
    var items:[[[String: AnyObject]]] = []
    
    func addSection(section: [String], item: [[String: AnyObject]]){
        sections = sections + [section]
        items = items + [item]
    }
    
    
}
