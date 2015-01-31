//
//  Category.swift
//  CoreDataRelationshipDemo
//
//  Created by Ian MacCallum on 1/30/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var tasks: NSSet

}
