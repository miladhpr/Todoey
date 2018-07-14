//
//  TaskCategory.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/12/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import Foundation
import RealmSwift


class TaskCategory: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}
