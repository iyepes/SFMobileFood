//
//  HCMFGeneralParams.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 25/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//
//  extension UIColor code modified from yannickl https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
//  extencion UIImage code modified from gotnull http://stackoverflow.com/questions/19274789/how-can-i-change-image-tintcolor-in-ios-and-watchkit/24545102#24545102

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString:String, alpha:CGFloat) {
        let hexString:NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context,CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class HCMFGeneralParams: NSObject {

    //App appereance
    let appColor:UIColor = UIColor(hexString: "177EB7",alpha: 1.0)
    let selectedColor:UIColor = UIColor(hexString: "07283B",alpha: 1.0)
    let textColor:UIColor = UIColor(hexString: "FFFFFF",alpha: 1.0)
    let backgroundColor:UIColor = UIColor(hexString: "07283B",alpha: 1.0)
    let unselectedColor:UIColor = UIColor.lightGrayColor() //AAAAAA
    
}
