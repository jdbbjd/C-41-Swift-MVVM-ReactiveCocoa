//
//  LyTimerViewModel.swift
//  Swift-C41
//
//  Created by ly on 16/8/3.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import AudioToolbox
import ReactiveCocoa

class LyTimerViewModel: NSObject {
    let recipeName = MutableProperty<String>("")
    let currentStepString = MutableProperty<String>("")
    let nextStepString = MutableProperty<String>("")
    let timeRemainingString = MutableProperty<String>("")
    let running = MutableProperty<Bool>(false)
    let complete = MutableProperty<Bool>(false)
    let currentStepIndex = MutableProperty<Int>(0)
    let currentStepTimeRemaining = MutableProperty<CFTimeInterval>(0)
    let timer = MutableProperty<NSTimer?>(nil)
    
    var model:LyRecipe!
    
    init(model:LyRecipe) {
        
        self.model = model
        
        recipeName <~ ConstantProperty(model.name ?? "")
        currentStepTimeRemaining <~ ConstantProperty(CFTimeInterval((self.model.steps?.objectAtIndex(0) as! LyStep).duration))
        
        let producer = combineLatest(ConstantProperty(model.steps).producer, currentStepIndex.producer)
        
        currentStepString <~ producer.map { (steps, currentIndex) -> String in
            if currentIndex < steps?.count && currentIndex >= 0
            {
                let step = steps?.objectAtIndex(currentIndex) as! LyStep
                let temperatureString = "\(step.temperatureC)℃"
                return "\(step.name ?? "") - \(temperatureString)"
            }
            return ""
        }
        
        nextStepString <~ producer.map({ (steps, currentIndex) -> String in
            let nextIndex = currentIndex + 1
            if nextIndex >= 0 && nextIndex < steps?.count
            {
                return (steps?.objectAtIndex(nextIndex) as! LyStep).name ?? ""
            }
            return ""
        })
        
        timeRemainingString <~ currentStepTimeRemaining.producer.map({ (time) -> String in
            let IntTime = Int(time)
            let minutes = IntTime / 60
            let seconds = IntTime % 60
            return String(format: "%d:%02d", minutes,seconds)
        })
        
        complete <~ producer.map({ (steps, currentIndex) -> Bool in
            return currentIndex < 0 || currentIndex >= steps?.count
        })
        
        running <~ self.timer.producer.map({$0 != nil})
    }
    
    //MARK: - Public Methods
    
    func pause() {
        self.timer.value!.invalidate()
        self.timer.value = nil
    }
    
    func resume() {
        if (self.timer.value == nil) {
            self.timer.value = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LyTimerViewModel.clockTick(_:)), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - Private Methods
    
    @objc private func clockTick(timer: NSTimer) {
        self.currentStepTimeRemaining.value -= 1
    
        if (self.currentStepTimeRemaining.value < 0) {
            self.currentStepIndex.value += 1
    
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
            if (self.currentStepIndex.value >= self.model.steps!.count) {
                self.pause()
            } else {
                self.currentStepTimeRemaining <~ ConstantProperty(CFTimeInterval((self.model.steps?.objectAtIndex(currentStepIndex.value) as! LyStep).duration))
            }
        }
    
    }
}
