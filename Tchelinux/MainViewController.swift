//
//  ViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 18/08/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UITabBarController {

    // MARK: Model    
    var events = [Event]() {
        didSet {
            print("Changing EVENT")
            if let vc = nextVC as? EventTableViewController {
                print("About to change events on view controller.")
                vc.events = events
            } else {
                print("It's another VC...")
            }
        }
    }
    
    // MARK: Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let base_url = "https://tchelinux.org/json/"
        let list_of_events = "eventos.json"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.load_events(from: base_url, file: list_of_events)
        }
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
        
        func process(_ evt: [String:Any]?, id: String) {
            if let event = evt {
                let eventData: Event
                let institute: Institution
                
                if let institution: [String:Any] = event["institution"] as? [String : Any],
                    let name = institution["long_name"] as? String,
                    let address = institution["address"] as? String,
                    let url = institution["url"] as? String
                {
                    institute = Institution(name: name, address: address, url: url)
                } else {
                    return
                }

                if let city = event["city"] as? String,
                    let date = Date.fromString(event["date"] as? String)
                {
                    eventData = Event(id: id, city: city, date: date, institution: institute)
                } else {
                    return
                }
                /*
                let callForPapers: [String:Any] = event["callForPapers"] as! [String : Any]
                print("Chamada de Trabalhos: \(callForPapers["deadline"] ?? "error")")
                print("Notificação: \(callForPapers["notificação"] ?? "error")")
                
                let enrollment: [String:Any] = event["enrollment"] as! [String : Any]
                print("Abertura das Inscrições: \(enrollment["deadline"] ?? "error")")
                print("Inscrições: \((enrollment["closed"] as? Bool)! ? "fechadas" : "abertas")")
                 */
                
                print("Added \(eventData.id)")
                DispatchQueue.main.async { [weak self] in self?.events.append(eventData) }
            } else {
                print("Failed to load event \(id)")
                return
            }
            
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for evt in (loadJSONObject(from: from+file) as? [Any]) ?? [] {
                if let event = evt as? [String:Any] {
                    print("Event id: \(event["id"] as! String) updated: \(event["updated"] as! String)")
                    let eventURL = from + (event["id"] as! String) + ".json"
                    print ("Loading event from: \(eventURL)")
                    if let eventData = loadJSONObject(from: eventURL) {
                        process(eventData as? [String:Any], id: event["id"] as! String)
                    }
                }
            }
        }
    }
}

extension Foundation.Date {
    static func fromString(_ date: String?) -> Date? {
        if let d = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy'-'MM'-'dd"
            let result = formatter.date(from: d)
            return result
        }
        return nil
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
