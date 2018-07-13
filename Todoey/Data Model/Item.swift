//
//  Item.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/12/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parent = LinkingObjects(fromType: TaskCategory.self, property: "items")
}
