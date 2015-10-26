//
//  HCMFTabBarViewController.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 25/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit

class HCMFTabBarViewController: UITabBarController {

    var currentParams: HCMFGeneralParams = HCMFGeneralParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBar.barTintColor = currentParams.appColor
        self.tabBar.tintColor = currentParams.selectedColor
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: currentParams.unselectedColor], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: currentParams.selectedColor], forState:.Selected)
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(currentParams.unselectedColor).imageWithRenderingMode(.AlwaysOriginal)
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
