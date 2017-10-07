//
//  EnrollmentTableViewCell.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 25/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventEnrollmentCell: UITableViewCell {


    @IBOutlet weak var enrollmentLabel: UILabel!
    @IBOutlet weak var enrollmentButton: UIButton!

    var url: URL?

    @IBOutlet weak var webButton: UIButton!
    
    @IBAction func websiteButton(_ sender: UIButton) {
        if let site = url {
            UIApplication.shared.open(site, options: [:], completionHandler: nil)
        }
    }

}
