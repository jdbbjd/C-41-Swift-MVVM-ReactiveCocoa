//
//  LyStep+CoreDataProperties.swift
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

extension LyStep {

    @NSManaged var agitationDuration: Int64
    @NSManaged var agitationFrequency: Int64
    @NSManaged var blurb: String?
    @NSManaged var duration: Int64
    @NSManaged var name: String?
    @NSManaged var temperatureC: Int64
    @NSManaged var recipe: LyRecipe?

}
