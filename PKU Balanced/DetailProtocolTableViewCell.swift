//
//  DetailProtocolTableViewCell.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 23.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class DetailProtocolTableViewCell: UITableViewCell {

    @IBOutlet weak var pheValue: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
