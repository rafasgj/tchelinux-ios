//
//  EventDetailViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 21/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventDetailViewController: UITableViewController {
    
    var event: Event? {
        didSet { updateUI() }
    }

    private func updateUI() {
        
    }
    
    // MARK: - Table view data source

    private let sections = ["","Intituição"]
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // go away! change the number of sections!
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "heading", for: indexPath) as! EventHeadingCell
            if let evt = event {
                cell.cityLabel?.text = evt.city
                cell.dateLabel?.text = (evt.date! as Date).inPortuguese
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "institution", for: indexPath) as! EventInstitutionCell
            if let evt = event {
                cell.instituteLabel?.text = evt.institution?.name
                cell.addressLabel?.text = evt.institution?.address
                if let site = evt.institution?.url {
                    cell.url = URL(string: site)
                }
            }
            return cell

        default:
            // we should never get here...
            let cell = tableView.dequeueReusableCell(withIdentifier: "heading", for: indexPath) as! EventHeadingCell
            cell.cityLabel?.text = ""
            cell.dateLabel?.text = ""
            return cell
        }
    }

}
