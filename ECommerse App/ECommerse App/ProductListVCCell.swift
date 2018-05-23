//
//  ProductListVCCell.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 21/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

class ProductListVCCell: UITableViewCell {

    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblDateAdded: UILabel!
    @IBOutlet var lblTaxDetail: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
