//
//  LyRecipe+CoreDataProperties.swift
//  Swift-C41
//
//  Created by ly on 16/8/1.
//  Copyright © 2016年 ly. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LyRecipe {

    @NSManaged var blurb: String?
    @NSManaged var notes: String?
    @NSManaged var name: String?
    @NSManaged var filmType: Int64
    @NSManaged var steps: NSOrderedSet?

}
