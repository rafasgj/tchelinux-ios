//
//  Institution.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 22/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData

class Institution: NSManagedObject {

    static func retrieveOrCreate(name:String, url:String, context: NSManagedObjectContext) throws -> Institution?
    {
        // Note that Swift CANNOT infer the type correctly!
        let request: NSFetchRequest<Institution> = Institution.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ and url == %@", name, url)
        
        do {
            let result = try context.fetch(request)
            assert(result.count <= 1, "\(#function): Database inconsistency found.")
            if result.count > 0 {
                return result.first
            }
        } catch {
            throw error
        }
        
        let institution = Institution(context: context)
        institution.name = name
        institution.url = url
        
        return institution
    }
    
    func updateWithJSONData(data: [String:Any]) {
        self.address = data["address"] as? String
        self.logo = data["logo"] as? String
        self.longitude = (data["longitude"] as? Double) ?? 0
        self.latitude = (data["latitude"] as? Double) ?? 0
    }
}
