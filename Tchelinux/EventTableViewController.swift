//
//  EventTableViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 20/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    var events: [Event]?
    {
        didSet { eventList?.reloadData() }
    }
    
    var filter: (Event) -> Bool = { e in return true }
    {
        didSet { eventList?.reloadData() }
    }
    
    var order: (Event,Event) -> Bool = { a,b in return true }
    {
        didSet { eventList?.reloadData() }
    }
    
    private var orderedList: [Event]? {
        return events?.filter(filter).sorted(by:order)
    }
    
    @IBOutlet var eventList: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Will apear \((self.navigationItem.title ?? "WHO KNOWS?"))")
        
        if let title = self.navigationItem.title {
            switch title {
            case "Agenda":
                filter = { $0.date >= Date() }
                order = {$0.date < $1.date }
            case "Resultados":
                filter = { $0.date < Date() }
                order = {$0.date > $1.date }
            default: break
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.filter(filter).count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        if let list = orderedList {
            let event = list[indexPath.row]
            cell.textLabel?.text = event.city
            cell.detailTextLabel?.text = event.date.inPortuguese
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let list = orderedList, let vc = segue.destination as? EventDetailViewController,
            let e = eventList?.indexPathForSelectedRow?.row
        {
            print("The list:")
            for item in list {
                print(item.city)
            }
            print("The index: \(e)")
            print("Segue with \(list[e].city)")
            vc.event = list[e]
        }
    }

}
