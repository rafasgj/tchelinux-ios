//
//  CallForPapers.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 24/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData

class CallForPapers: NSManagedObject {

    func updateWithJSONData(data: [String:Any]) {
        self.start = Date.fromString(data["start"] as? String) as NSDate?
        self.deadline = Date.fromString(data["deadline"] as? String) as NSDate?
        self.url = data["url"] as? String
    }
}
