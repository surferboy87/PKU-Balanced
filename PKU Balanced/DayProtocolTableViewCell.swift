//
//  DayProtocolTableViewCell.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 17.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class DayProtocolTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var calculatedPheValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
