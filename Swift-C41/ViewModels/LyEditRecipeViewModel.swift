//
//  LyEditRecipeViewModel.swift
//  Swift-C41
//
//  Created by ly on 16/8/2.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LyEditRecipeViewModel: NSObject {

    var blurb = MutableProperty<String>("")
    var name = MutableProperty<String>("")
    var filmType = MutableProperty<Int64>(0)
    var inserting = ConstantProperty<Bool>(false)
//    var shouldShowCancelButton:Bool{
//        get{
//            return inserting
//        }
//    }
    
    var model:LyRecipe!
    
    init(model:LyRecipe) {
        super.init()
        self.model = model
        
        name.value = self.model.name ?? ""
        blurb.value = self.model.blurb ?? ""
        filmType.value = self.model.filmType ?? 0
        
        name.producer.startWithNext { [unowned self] value in
            self.model.name = value
        }
        blurb.producer.startWithNext { [unowned self] value in
            self.model.blurb = value
        }
        filmType.producer.startWithNext { [unowned self] value in
            self.model.filmType = value
        }
    }
    
    func numberOfSteps() -> NSInteger
    {
        return (model.steps?.count)!
    }
    
    func cancel()
    {
        if inserting.value {
            self.model.managedObjectContext?.deleteObject(self.model)
        }
    }
    
    func willDismiss()
    {
        try! self.model.managedObjectContext?.save()
    }
    
    
    func sectionForFilmTpe(filmType:Int64) -> Int{
        return Int(filmType)
    }
    
    func filmTypeForSection(section: Int) -> Int64 {
        return Int64(section)
    }
    
    func titleForFilmTyle(filmType:Int64) -> String? {
        
        switch filmType {
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
    
    func isFilmTypeOfModel(filmType:Int64) ->Bool{
        return self.model.filmType == filmType
    }
    
    func addStep() {
        
        let step = LyStep.step(nil, name: "New Step", blurb: nil, temperatureC: LyEditStepViewModelDefaultTemperature, duration: 0, agitationDuration: LyEditStepViewModelDefaultAgitationDuration, agitationFrequency: LyEditStepViewModelDefaultAgitationFrequency)

        let stepsMutableOrderedSet  = NSMutableOrderedSet(orderedSet: self.model.steps!)
        stepsMutableOrderedSet.addObject(step)
    
        self.model.steps = NSOrderedSet(orderedSet: stepsMutableOrderedSet)
    }
    
    func removeStepAtIndex(index: NSInteger) {
    
        let stepsMutableOrderedSet  = NSMutableOrderedSet(orderedSet: self.model.steps!)
        assert(index < stepsMutableOrderedSet.count && index >= 0,"Index must be within bounds of mutable set.")
        stepsMutableOrderedSet.removeObjectAtIndex(index)
    
        self.model.steps = NSOrderedSet(orderedSet: stepsMutableOrderedSet)
    }
    
    func moveStepFromIndex(fromIndex:NSInteger, toIndex:NSInteger) {
    
        let step = self.model.steps!.objectAtIndex(fromIndex)
    
        let mutableSteps = NSMutableOrderedSet(orderedSet: self.model.steps!)
        mutableSteps.removeObjectAtIndex(fromIndex)
        mutableSteps.insertObject(step, atIndex: toIndex)
    
        self.model.steps = mutableSteps
    }
    
    func stepTitleAtIndex(index: NSInteger) -> String? {
        return self.stepAtIndex(index)?.name
    }
    
    func stepAtIndex(index: NSInteger) -> LyStep?{
        return self.model.steps?.objectAtIndex(index) as? LyStep
    }
    
    func editStepViewModelAtIndex(index: NSInteger) -> LyEditStepViewModel{
        
        return LyEditStepViewModel(model:self.stepAtIndex(index)!)
    }
}
