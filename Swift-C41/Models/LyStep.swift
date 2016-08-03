//
//  LyStep.swift
//  Swift-C41
//
//  Created by ly on 16/8/1.
//  Copyright © 2016年 ly. All rights reserved.
//

import Foundation
import CoreData


class LyStep: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func step(recipe: LyRecipe?, name: String, blurb: String? , temperatureC: Int64, duration: Int64, agitationDuration:Int64, agitationFrequency:Int64) -> LyStep
    {
        let step = NSEntityDescription.insertNewObjectForEntityForName("LyStep", inManagedObjectContext: LyCoreDataStack.defaultStack.managedObjectContext) as! LyStep
        step.recipe = recipe
        step.name = name
        step.blurb = blurb
        step.temperatureC = temperatureC
        step.duration = duration
        step.agitationDuration = agitationDuration
        step.agitationFrequency = agitationFrequency
        
        return step
    }
}
