//
//  LyRecipe.swift
//  Swift-C41
//
//  Created by ly on 16/8/1.
//  Copyright © 2016年 ly. All rights reserved.
//

import Foundation
import CoreData

enum LyRecipeFilmType:Int64 {
    case LyRecipeFilmTypeColourNegative,
    LyRecipeFilmTypeColourPositive,
    LyRecipeFilmTypeBlackAndWhite
}
    
class LyRecipe: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func Recipe(name:String, blurb:String ,filmType:LyRecipeFilmType) -> LyRecipe {
        let Recipe = NSEntityDescription.insertNewObjectForEntityForName("LyRecipe", inManagedObjectContext: LyCoreDataStack.defaultStack.managedObjectContext) as! LyRecipe
        Recipe.name = name
        Recipe.blurb = blurb
        Recipe.filmType = filmType.rawValue
        return Recipe
    }
}
