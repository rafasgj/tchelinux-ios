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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Cidade"
            cell.detailTextLabel?.text = event?.city
        case 1:
            cell.textLabel?.text = "Data"
            if let e = event {
                cell.detailTextLabel?.text = (e.date! as Date).inPortuguese
            } else {
                cell.detailTextLabel?.text = ""
            }
        case 2:
            cell.textLabel?.text = "Nome"
            if let institution = event?.institution {
                cell.detailTextLabel?.text = institution.name
            }
        case 3:
            cell.textLabel?.text = "Endereço"
            if let institution = event?.institution {
                cell.detailTextLabel?.text = institution.address
            }
        default: break
        }

        return cell
    }

}
