//
//  LyDetailViewModel.swift
//  Swift-C41
//
//  Created by ly on 16/8/3.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LyDetailViewModel: NSObject {
    
    var model:LyRecipe!
    
    let recipeName = MutableProperty<String>("")
    let recipeDescription = MutableProperty<String>("")
    let recipeFilmTypeString = MutableProperty<String>("")
    let numberOfSteps = MutableProperty<Int>(0)
    let canStartTimer = MutableProperty<Bool>(false)
    
    init(model:LyRecipe) {
//        super.init()
        self.model = model
        
        recipeName <~ ConstantProperty(model.name ?? "")
        recipeDescription <~ ConstantProperty(model.blurb ?? "")
        recipeFilmTypeString <~ ConstantProperty(model.filmType).producer.map({
            switch $0{
            case LyRecipeFilmType.LyRecipeFilmTypeBlackAndWhite.rawValue:
                return "Black and White"
            case LyRecipeFilmType.LyRecipeFilmTypeColourNegative.rawValue:
                return "Colour Negative"
            default:
                return "Colour Positive"
            }
        })
        
        numberOfSteps <~ ConstantProperty(model.steps).producer.map({$0!.count})
        canStartTimer <~ ConstantProperty(model.steps).producer.map({$0?.count > 0})
    }
    
    //MARK: - Private Methods
    
     func stepAtIndex(index:Int) -> LyStep {
        return self.model.steps!.objectAtIndex(index) as! LyStep
    }
    
    //MARK: - Public Methods
    
    func titleForStepAtIndex(index:Int) -> String?{
        return self.stepAtIndex(index).name
    }
    
    func subtitleForStepAtIndex(index:Int) -> String {
        let duration = self.stepAtIndex(index).duration
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%ld:%02d", minutes,seconds)
    }
    
    func timerViewModel() -> LyTimerViewModel {
        return LyTimerViewModel(model: self.model)
    }
}
