//
//  HelperStructs.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 20/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import Foundation

struct Institution {
    var name: String
    var address: String
    var url: String
}
struct Event {
    var id: String
    var city: String
    var date: Date
    var institution: Institution
}
