//
//  EventInstitutionCell.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 23/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventInstitutionCell: UITableViewCell {

    @IBOutlet weak var instituteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var url: URL?
    
    @IBAction func websiteButton(_ sender: UIButton) {
        if let site = url {
            UIApplication.shared.open(site, options: [:], completionHandler: nil)
        }
    }
}
