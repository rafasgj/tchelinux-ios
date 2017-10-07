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
        
        let base_json = "https://tchelinux.org/json/eventos.json"
        if let context = AppDelegate.persistentContainer?.viewContext {
            DispatchQueue.global(qos: .userInitiated).async { [weak self, weak context] in
                if context != nil
                { self?.load_events(from: base_json, context: context!) }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()
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
    
    private func load_events(from: String, context: NSManagedObjectContext) {
        
        func loadJSONObject(from:String) -> Any?
        {
            if let url = URL(string: from),
                let data = try? Data(contentsOf: url),
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
            { return json }
            return nil
        }
        
        func process(_ evt: [String:Any]?, evtinfo: (id:String, updated:Date), context: NSManagedObjectContext) {
            if let eventData = evt,
                let event = (try? Event.retrieveOrCreate(event: evtinfo.id, context: context)) ?? nil
            {
                event.updateWithJSONData(data:eventData, updated: evtinfo.updated)

                if let institute: [String:Any] = eventData["institution"] as? [String : Any],
                    let institution = try? Institution.retrieveOrCreate(name: institute["long_name"] as! String,
                                                                        url: institute["url"] as! String, context: context)
                {
                    institution?.updateWithJSONData(data: institute)
                    event.institution = institution
                }
                if let call4Papers: [String:Any] = eventData["callForPapers"] as? [String : Any]
                {
                    if event.callForPapers == nil {
                        event.callForPapers = CallForPapers(context: context)
                    }
                    event.callForPapers?.updateWithJSONData(data: call4Papers)
                }

                if let enrollment: [String:Any] = eventData["enrollment"] as? [String : Any] {
                    if event.enrollment == nil {
                        event.enrollment = Enrollment(context: context)
                    }
                    event.enrollment?.updateWithJSONData(data: enrollment)
                }
                DispatchQueue.main.async { [weak self] in self?.updateUI() }
            } else {
                print("Failed to parse event.")
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for evt in (loadJSONObject(from: from) as? [Any]) ?? [] {
                DispatchQueue.global(qos: .userInitiated).async { [weak context] in
                    if let event = evt as? [String:Any]
                    {
                        let codename = event["id"] as! String
                        let updated = (event["updated"] as! String)
                        let evtinfo = (id: codename, updated: (Date.fromString(updated) ?? Date()))
                        let jsonFile = "https://\(codename).tchelinux.org/data/\(codename).json"
                        print("Event id: \(codename) updated: \(updated)")

                        if let c = context, Event.needsUpdate(evtinfo, context: c) {
                            print ("Loading event from: \(jsonFile)")
                            if let eventData = loadJSONObject(from: jsonFile) as? [String:Any] {
                                print ("Processing: \(eventData["id"] as! String)")
                                process(eventData, evtinfo: evtinfo, context: c)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async { [weak self, weak context] in
                if let c = context {
                    do {
                        try c.save()
                    } catch {
                        print("Failed: \(error)")
                    }
                }
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
