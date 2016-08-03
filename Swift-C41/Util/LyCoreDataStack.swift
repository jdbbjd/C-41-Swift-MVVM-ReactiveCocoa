//
//  LyCoreDataStack.swift
//  Swift-C41
//
//  Created by ly on 16/7/29.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class LyCoreDataStack: NSObject {

    class var defaultStack : LyCoreDataStack {
        struct Static {
            static let instance = LyCoreDataStack()
        }
        return Static.instance
    }
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    lazy var managedObjectContext:NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        
        let objectContext = NSManagedObjectContext()
        objectContext.persistentStoreCoordinator = coordinator
        
        return objectContext
        
    }()
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    lazy var managedObjectModel:NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Swift-C41", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL:modelURL!)!
    }()
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator = {
        let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("Swift_C_41.sqlite")
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel)
        
        do {
            try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch let error {
            print("Unresolved error :\(error)")
        }
        
        return storeCoordinator
    }()
    
    override init() {
        super.init()
    }
    
    func applicationDocumentsDirectory() -> NSURL {
    return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
    
    //MARK: - Public Methods
    func ensureInitialLoad() {
        let initialLoadKey = "Initial Load"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let hasInitialLoad = userDefaults.boolForKey(initialLoadKey)
        
        if !hasInitialLoad {
            userDefaults.setBool(true, forKey: initialLoadKey)
            
            let c41Recipe = LyRecipe.Recipe("C-41 Colour Process", blurb: "Standard C-41 colour negative film recipe.", filmType: .LyRecipeFilmTypeColourNegative)
            let prewashStep = LyStep.step(c41Recipe, name: "Prewash", blurb: "Water", temperatureC: 39, duration: 60, agitationDuration: 0, agitationFrequency: 0)
            let developerStep = LyStep.step(c41Recipe, name: "Developer", blurb: nil, temperatureC: 39, duration: 210, agitationDuration: 10, agitationFrequency: 60)
            let blixStep = LyStep.step(c41Recipe, name: "Blix", blurb: nil, temperatureC: 39, duration: 390, agitationDuration: 10, agitationFrequency: 60)
            let washStep = LyStep.step(c41Recipe, name: "Wash", blurb: "Water", temperatureC: 23, duration: 180, agitationDuration: 0, agitationFrequency: 0)
            let stabilizerStep = LyStep.step(c41Recipe, name: "Stabilizer", blurb: nil, temperatureC: 23, duration: 60, agitationDuration: 15, agitationFrequency: 60)
            c41Recipe.steps = NSOrderedSet(array: [prewashStep, developerStep, blixStep, washStep, stabilizerStep])
            
            let e6Recipe = LyRecipe.Recipe("E-6 Colour Process", blurb: "Standard E-6 colour positive film recipe.", filmType: .LyRecipeFilmTypeColourPositive)
            let e6prewashStep = LyStep.step(e6Recipe, name: "Prewash", blurb: "Water", temperatureC: 38, duration: 60, agitationDuration: 0, agitationFrequency: 0)
            let firstDeveloperStep = LyStep.step(e6Recipe, name: "First Developer", blurb: nil, temperatureC: 38, duration: 360, agitationDuration: 5, agitationFrequency: 15)
            let firstWashStep = LyStep.step(e6Recipe, name: "Wash", blurb: "Water", temperatureC: 38, duration: 150, agitationDuration: 0, agitationFrequency: 0)
            let colourDeveloperStep = LyStep.step(e6Recipe, name: "Colour Developer", blurb: nil, temperatureC: 38, duration: 360, agitationDuration: 5, agitationFrequency: 15)
            let secondWashStep = LyStep.step(e6Recipe, name: "Wash", blurb: "Water", temperatureC: 38, duration: 150, agitationDuration: 0, agitationFrequency: 0)
            let e6blixStep = LyStep.step(e6Recipe, name: "Blix", blurb: nil, temperatureC: 38, duration: 360, agitationDuration: 5, agitationFrequency: 15)
            let finalWashStep = LyStep.step(e6Recipe, name: "Wash", blurb: "Water", temperatureC: 38, duration: 240, agitationDuration: 0, agitationFrequency: 0)
            e6Recipe.steps = NSOrderedSet(array: [e6prewashStep, firstDeveloperStep, firstWashStep, colourDeveloperStep, secondWashStep, e6blixStep, finalWashStep])
            
            let delta3200Recipe = LyRecipe.Recipe("Ilford Delta 3200", blurb: "Black and white process for Ilford’s high-ISO film.", filmType: .LyRecipeFilmTypeBlackAndWhite)
            let delta3200developerStep = LyStep.step(delta3200Recipe, name: "Developer", blurb: "Ilfosol", temperatureC: 23, duration: 600, agitationDuration: 10, agitationFrequency: 60)
            let stopBathStep = LyStep.step(delta3200Recipe, name: "Stop Bath", blurb: "Ilfostop", temperatureC: 23, duration: 10, agitationDuration: 10, agitationFrequency: 0)
            let fixerStep = LyStep.step(delta3200Recipe, name: "Fixer", blurb: "Ilford Rapid Fixer", temperatureC: 23, duration: 280, agitationDuration: 10, agitationFrequency: 60)
            let delta3200washStep = LyStep.step(delta3200Recipe, name: "Wash", blurb: "Water", temperatureC: 23, duration: 300, agitationDuration: 0, agitationFrequency: 0)
            delta3200Recipe.steps = NSOrderedSet(array: [delta3200developerStep, stopBathStep, fixerStep, delta3200washStep])
            
            let delta400Recipe = LyRecipe.Recipe("Ilford Delta 400", blurb: "Black and white process for Ilford’s high-ISO film.", filmType: .LyRecipeFilmTypeBlackAndWhite)
            let delta400developerStep = LyStep.step(delta400Recipe, name: "Developer", blurb: "Ilfosol", temperatureC: 20, duration: 540, agitationDuration: 10, agitationFrequency: 60)
            let delta400stopBathStep = LyStep.step(delta400Recipe, name: "Stop Bath", blurb: "Ilfostop", temperatureC: 20, duration: 10, agitationDuration: 10, agitationFrequency: 0)
            let delta400fixerStep = LyStep.step(delta400Recipe, name: "Fixer", blurb: "Ilford Rapid Fixer", temperatureC: 20, duration: 180, agitationDuration: 10, agitationFrequency: 60)
            let delta400washStep = LyStep.step(delta400Recipe, name: "Wash", blurb: "Water", temperatureC: 20, duration: 300, agitationDuration: 0, agitationFrequency: 0)
            delta400Recipe.steps = NSOrderedSet(array: [delta400developerStep, delta400stopBathStep, delta400fixerStep, delta400washStep])
            
            let delta100Recipe = LyRecipe.Recipe("Ilford Delta 100", blurb: "Black and white process for Ilford’s high-ISO film.", filmType: .LyRecipeFilmTypeBlackAndWhite)
            let delta100developerStep = LyStep.step(delta100Recipe, name: "Developer", blurb: "Ilfosol", temperatureC: 20, duration: 360, agitationDuration: 10, agitationFrequency: 60)
            let delta100stopBathStep = LyStep.step(delta100Recipe, name: "Stop Bath", blurb: "Ilfostop", temperatureC: 20, duration: 10, agitationDuration: 10, agitationFrequency: 0)
            let delta100fixerStep = LyStep.step(delta100Recipe, name: "Fixer", blurb: "Ilford Rapid Fixer", temperatureC: 20, duration: 180, agitationDuration: 10, agitationFrequency: 60)
            let delta100washStep = LyStep.step(delta100Recipe, name: "Wash", blurb: "Water", temperatureC: 20, duration: 300, agitationDuration: 0, agitationFrequency: 0)
            delta100Recipe.steps = NSOrderedSet(array: [delta100developerStep, delta100stopBathStep, delta100fixerStep, delta100washStep])
            
            LyCoreDataStack.defaultStack.saveContext()
        }
    }

    func saveContext() {
        if self.managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }catch let error {
                print("Unresolved error: \(error)")
                abort()
            }
        }
    }

}
