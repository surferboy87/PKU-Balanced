//
//  ProtocolTableViewCell.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 22.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProtocolTableViewCell: UITableViewCell {

    @IBOutlet weak var protocolDate: UILabel!
    @IBOutlet weak var pheValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
