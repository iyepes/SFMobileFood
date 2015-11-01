//
//  HCMFHeaderTableViewCell.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 30/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit

class HCMFHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var cartName: UILabel!
    
    @IBOutlet weak var cartFood: UILabel!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var headerContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func toggleOpen(sender: AnyObject) {
        self.toggleOpenWithUserAction(true)
    }

    func toggleOpenWithUserAction(userAction: Bool) {
    
        // toggle the expand button state
        self.expandButton.selected = !self.expandButton.selected
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
