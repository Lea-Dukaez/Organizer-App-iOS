//
//  Category.swift
//  OrganizerApp
//
//  Created by Léa on 09/06/2020.
//  Copyright © 2020 Lea Dukaez. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    var items = List<Item>()
}
