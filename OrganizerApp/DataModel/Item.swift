//
//  Item.swift
//  OrganizerApp
//
//  Created by Léa on 09/06/2020.
//  Copyright © 2020 Lea Dukaez. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
