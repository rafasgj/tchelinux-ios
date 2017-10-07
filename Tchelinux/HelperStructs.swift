//
//  HelperStructs.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 20/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation
import UIKit

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
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
            let result = formatter.date(from: d+"T23:59:59")
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

// MARK: Ease string formating.

extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
