//
//  ListraLivrosExtension.swift
//  Book Catalog
//
//  Created by Rafael Jeffman on 21/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation

//
//  CoreDataTableViewController.swift
//  Diário de Classe
//
//  Created by Rafael Jeffman on 20/09/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import UIKit
import CoreData

extension EventTableViewController
{    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let obj = fetchedResultsController?.object(at: indexPath),
                let context = container?.viewContext
            {
                context.delete(obj as NSManagedObject)
                do {
                    try context.save()
                } catch let error {
                    print("\(error)")
                }
            }
        default: break
        }
    }
}
