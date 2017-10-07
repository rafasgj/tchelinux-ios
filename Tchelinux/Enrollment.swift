//
//  Enrollment.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 24/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData

class Enrollment: NSManagedObject {
    func updateWithJSONData(data: [String:Any]) {
        if let available = data["availability"] as? String {
            self.availability = Int16(available) ?? 200
        } else {
            self.availability = 200
        }
        self.start = Date.fromString(data["start"] as? String) as NSDate?
        self.deadline = Date.fromString(data["deadline"] as? String) as NSDate?
        self.url = data["url"] as? String
        self.closed = ((data["closed"] as? String) ?? "false") == "true"
    }
}
