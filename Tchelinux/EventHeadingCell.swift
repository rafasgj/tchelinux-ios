//
//  EventHeadingCell.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 23/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventHeadingCell: UITableViewCell {

    @IBOutlet weak var institutionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
