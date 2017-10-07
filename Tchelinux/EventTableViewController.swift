//
//  EventTableViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 20/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit
import CoreData

class EventTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    internal var fetchedResultsController: NSFetchedResultsController<Event>? {
        didSet {
            do {
                if let resultsController = fetchedResultsController {
                    resultsController.delegate = self
                    try resultsController.performFetch()
                    tableView.reloadData()
                }
            } catch let error {
                print("PerformFetch failed: \(error)")
            }
        }
    }
    
    @IBOutlet var eventList: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestFetchedResultsController()
    }
    
    // MARK: - CoreDataTableViewController FetchedResultsController setup
    
    private func requestFetchedResultsController() {
        let request = NSFetchRequest<Event>(entityName: "Event")
        var ascending = true
        if let title = self.navigationItem.title {
            switch title {
            case "Agenda":
                request.predicate = NSPredicate(format: "date >= %@", Date() as NSDate)
            case "Resultados":
                request.predicate = NSPredicate(format: "date < %@", Date() as NSDate)
                ascending = false
            default: break
            }
        }
        request.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: ascending) ]
        
        fetchedResultsController = getFetchedResultsController(for: request)
    }

    // MARK: - UITableView data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        if let event = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = event.city
            cell.detailTextLabel?.text = (event.date! as Date).inPortuguese
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventDetailViewController,
            let e = fetchedResultsController?.object(at: (eventList?.indexPathForSelectedRow!)!)
        {
            //print("Segue with \(e.city ?? "unknown city")")
            vc.event = e
        }
    }

}
