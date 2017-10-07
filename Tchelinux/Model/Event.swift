//
//  Event.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 22/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData

enum DatabaseError : Error {
    case inconsistentDatabase(String)

}

class Event: NSManagedObject {
    
    static func needsUpdate(_ evtinfo:(id:String,updated:Date), context: NSManagedObjectContext) -> Bool
    {
        // Note that Swift CANNOT infer the type correctly!
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "codename == %@", evtinfo.id)
        
        if let result = try? context.fetch(request) {
            if result.count > 0 {
                if let upd = result.first?.lastUpdate {
                    return upd <= (evtinfo.updated as NSDate)
                }
            }
        }
    
        return true
    }
    
    static func retrieveOrCreate(event codename:String, context: NSManagedObjectContext) throws -> Event?
    {
        // Note that Swift CANNOT infer the type correctly!
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "codename == %@", codename)
        
        do {
            let result = try context.fetch(request)
            assert(result.count <= 1, "\(#function): Database inconsistency found.")
            if result.count > 0 {
                return result.first
            }
        } catch {
            throw error
        }
        
        let event = Event(context: context)
        event.codename = codename
        return event
    }

    func updateWithJSONData(data: [String:Any], updated: Date) {
        self.lastUpdate = Date() as NSDate
        self.city = data["city"] as? String ?? ""
        self.date = Date.fromString(data["date"] as? String) as NSDate?
    }
}
