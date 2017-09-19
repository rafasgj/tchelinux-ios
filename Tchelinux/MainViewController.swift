//
//  ViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 18/08/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

// For JSONSerialization
import Foundation

class MainViewController: UITabBarController {

// MARK: Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let base_url = "https://tchelinux.org/json/"
        let list_of_events = "eventos.json"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.load_events(from: base_url, file: list_of_events)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Disappearing...")
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
            if evt == nil {
                print("Failed to load event \(id)")
                return
            }
            let event = evt!
            
            print("Cidade: \(event["city"]!)")
            print("Data: \(event["date"]!)")
            
            let institution: [String:Any] = event["callForPapers"] as! [String : Any]
            print("Instituição: \(institution["long_name"] ?? "error")")
            print("Endereço: \(institution["address"] ?? "error")")
            print("URL: \(institution["url"] ?? "error")")
            
            let callForPapers: [String:Any] = event["callForPapers"] as! [String : Any]
            print("Chamada de Trabalhos: \(callForPapers["deadline"] ?? "error")")
            print("Notificação: \(callForPapers["notificação"] ?? "error")")
            
            let enrollment: [String:Any] = event["enrollment"] as! [String : Any]
            print("Abertura das Inscrições: \(enrollment["deadline"] ?? "error")")
            print("Inscrições: \((enrollment["closed"] as? Bool)! ? "fechadas" : "abertas")")
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
    
//MARK: Other funcitions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

