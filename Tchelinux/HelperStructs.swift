//
//  HelperStructs.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 20/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation

// MARK: Allow NSDate to be comparable as with Date

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}

extension NSDate: Comparable { }

// MARK: Date utility functions

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
    var inPortuguese: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "pt_BR")
        formatter.dateFormat = "dd' de 'MMMM' de 'yyyy"
        return formatter.string(from: self)
    }
}
