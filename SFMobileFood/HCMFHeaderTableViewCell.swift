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
    
    @IBOutlet weak var expandArrow: UIImageView!
    
    @IBOutlet weak var collapseArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collapseArrow.hidden = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
