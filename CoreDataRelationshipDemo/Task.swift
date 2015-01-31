//
//  Task.swift
//  CoreDataRelationshipDemo
//
//  Created by Ian MacCallum on 1/30/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var category: Category
}
