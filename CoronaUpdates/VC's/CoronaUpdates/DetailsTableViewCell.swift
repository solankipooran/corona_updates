//
//  DetailsTableViewCell.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 03/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var totalConfirmed: UILabel!
    @IBOutlet weak var countryNamelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }

}
