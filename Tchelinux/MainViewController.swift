//
//  ViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 18/08/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MainViewController: UITabBarController {

    // MARK: Model    
    var events = [Event]()
    // MARK: Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let base_url = "https://tchelinux.org/json/"
        let list_of_events = "eventos.json"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.load_events(from: base_url, file: list_of_events)
        }
    }

    private func updateUI() {
        if let tableVC = nextVC as? EventTableViewController {
            tableVC.eventList?.reloadData()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        updateUI()
    }
    
    //MARK: JSON Objects
    
    private func load_events(from: String, file: String) {
        
        func loadJSONObject(from:String) -> Any?
        {
            if let url = URL(string: from),
                let data = try? Data(contentsOf: url),
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
            { return json }
            return nil
        }
        
        func process(_ evt: [String:Any]?, evtinfo: (id:String, updated:Date)) {
            if let eventData = evt,
                let context = AppDelegate.persistentContainer?.viewContext,
                let eventManagedObject = try? Event.retrieveOrCreate(event: evtinfo.id, context: context),
                let event = eventManagedObject
            {
                if let date: NSDate = event.lastUpdate, date <= (evtinfo.updated as NSDate) {
                    //print("Ignoring event \(evtinfo.id) since it exists and was not updated since \(evtinfo.updated)")
                    return
                }
                //print("Creating/changing \(evtinfo.id)")

                event.updateWithJSONData(data:eventData, updated: evtinfo.updated)

                if let institute: [String:Any] = eventData["institution"] as? [String : Any],
                    let institution = try? Institution.retrieveOrCreate(name: institute["long_name"] as! String,
                                                                        url: institute["url"] as! String, context: context)
                {
                    institution?.updateWithJSONData(data: institute)
                    event.institution = institution
                }
                
                /*
                let callForPapers: [String:Any] = event["callForPapers"] as! [String : Any]
                print("Chamada de Trabalhos: \(callForPapers["deadline"] ?? "error")")
                print("Notificação: \(callForPapers["notificação"] ?? "error")")
                
                let enrollment: [String:Any] = event["enrollment"] as! [String : Any]
                print("Abertura das Inscrições: \(enrollment["deadline"] ?? "error")")
                print("Inscrições: \((enrollment["closed"] as? Bool)! ? "fechadas" : "abertas")")
                 */
                DispatchQueue.main.async { [weak self] in self?.updateUI() }
            } else {
                print("Failed to load event \(evtinfo.id)")
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for evt in (loadJSONObject(from: from+file) as? [Any]) ?? [] {
                if let event = evt as? [String:Any] {
                    //print("Event id: \(event["id"] as! String) updated: \(event["updated"] as! String)")
                    //print ("Loading event from: \(eventURL)")
                    let eventURL = from + (event["id"] as! String) + ".json"
                    if let eventData = loadJSONObject(from: eventURL) {
                        let evtinfo = (id: event["id"] as! String,
                                       updated: (Date.fromString(event["updated"] as? String)) ?? Date())
                        process(eventData as? [String:Any], evtinfo: evtinfo)
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                try? AppDelegate.persistentContainer?.viewContext.save()
                self?.updateUI()
            }
        }
    }
    
}

extension UITabBarController {
    var nextVC: UIViewController? {
        if let nvc = selectedViewController as? UINavigationController {
            return nvc.visibleViewController
        } else {
            return selectedViewController
        }
    }
}
