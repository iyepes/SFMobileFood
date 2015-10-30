//
//  HCMFCartTableViewCell.swift
//  sfmobilefood
//
//  Created by Isabel Yepes on 22/10/15.
//  Copyright © 2015 Hacemos Contactos. All rights reserved.
//

import UIKit

class HCMFCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartName: UILabel!
    
    @IBOutlet weak var cartAddress: UILabel!
    
    @IBOutlet weak var cartFood: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        // line commented to avoid cell to be highligted when selected
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
