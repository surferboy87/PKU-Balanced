//
//  ProductTableViewCell.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 12.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

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
