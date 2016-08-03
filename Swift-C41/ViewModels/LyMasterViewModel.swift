//
//  LyMasterViewModel.swift
//  Swift-C41
//
//  Created by ly on 16/7/28.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import CoreData
import ReactiveCocoa
import Result

class LyMasterViewModel: NSObject,NSFetchedResultsControllerDelegate {

    var model:NSManagedObjectContext!
    var updatedContentSignal:Signal<Int?, NoError>!
    private var updatedContentObserver:Observer<Int?, NoError>!
    
    lazy var fetchedResultsController:NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("LyRecipe", inManagedObjectContext: self.model)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.model, sectionNameKeyPath: "filmType", cacheName: "Master")
        aFetchedResultsController.delegate = self;
        
        do{
            try aFetchedResultsController.performFetch()
        }catch let error
        {
        
            print("Unresolved error \(error)")
            abort();
            
        }
        
        return aFetchedResultsController
    }()
    
    init(model:NSManagedObjectContext) {
        super.init()
        self.model = model
        let updatedContentSignalPipe = Signal<Int?, NoError>.pipe()
        updatedContentSignal = updatedContentSignalPipe.0.observeOn(UIScheduler())
        updatedContentObserver = updatedContentSignalPipe.1
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        updatedContentObserver.sendNext(nil)
    }
    
    //MARK: - Public Methods
    
    func numberOfSections() -> NSInteger {
        return (self.fetchedResultsController.sections != nil) ? self.fetchedResultsController.sections!.count:0
    }
    
    func numberOfItemsInSection(section: NSInteger) ->NSInteger {
        let sectionInfo = self.fetchedResultsController.sections?[section]
        return sectionInfo == nil ? 0:sectionInfo!.numberOfObjects
    }
    
    
    func deleteObjectAtIndexPath(indexPath: NSIndexPath) {
        
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! LyRecipe
        let context = self.fetchedResultsController.managedObjectContext
        context.deleteObject(object)
    
        for tmpstep in object.steps! {
            let step = tmpstep as! LyStep
            context.deleteObject(step)
        }
        
        do{
            try context.save()
        }
        catch let error {
            print("Unresolved error \(error)")
            abort()
        }
    }
    
    func titleForSection(section: NSInteger) -> String? {
        let sectionInfo = self.fetchedResultsController.sections?[section]
        let sectionObjects = sectionInfo?.objects as? [LyRecipe]
        let representativeObject = sectionObjects?.first
    
        if (representativeObject != nil) {
            switch representativeObject!.filmType {
            case LyRecipeFilmType.LyRecipeFilmTypeBlackAndWhite.rawValue:
                return "Black and White"
            case LyRecipeFilmType.LyRecipeFilmTypeColourNegative.rawValue:
                return "Colour Negative"
            case LyRecipeFilmType.LyRecipeFilmTypeColourPositive.rawValue:
                return "Colour Positive"
            default:
                return nil
            }
            
        }
    
        return nil
    }
    
    func titleAtIndexPath(indexPath:NSIndexPath) -> String?{
        let recipe = self.recipeAtIndexPath(indexPath)
        return recipe.valueForKeyPath("name") as? String
    }
    
    func subtitleAtIndexPath(indexPath:NSIndexPath) -> String? {
        let recipe = self.recipeAtIndexPath(indexPath)
        return recipe.valueForKeyPath("blurb") as? String
    }
    
    
    func detailViewModelForIndexPath(indexPath: NSIndexPath) -> LyDetailViewModel {
        return LyDetailViewModel(model:self.recipeAtIndexPath(indexPath))
    }

    func editViewModelForIndexPath(indexPath: NSIndexPath) -> LyEditRecipeViewModel{
        return LyEditRecipeViewModel(model: self.recipeAtIndexPath(indexPath))
    }
    
    func editViewModelForNewRecipe() -> LyEditRecipeViewModel{
        let recipe = NSEntityDescription.insertNewObjectForEntityForName("LyRecipe", inManagedObjectContext: self.model) as! LyRecipe
        let viewModel = LyEditRecipeViewModel(model: recipe)
        viewModel.inserting = ConstantProperty(true)
        return viewModel
    }
    
    private func recipeAtIndexPath(indexPath:NSIndexPath) -> LyRecipe {
        return self.fetchedResultsController.objectAtIndexPath(indexPath) as! LyRecipe
    }
}
