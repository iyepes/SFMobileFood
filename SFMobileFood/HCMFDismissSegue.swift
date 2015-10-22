//
//  HCMFDismissSegue.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 25/09/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import Foundation
import UIKit

class DismissSegue: UIStoryboardSegue {

    override func perform() {
        var sourceViewController = self.sourceViewController as! ViewController
        sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}