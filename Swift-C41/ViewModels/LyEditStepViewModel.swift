//
//  LyEditStepViewModel.swift
//  Swift-C41
//
//  Created by ly on 16/8/2.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

let LyEditStepViewModelDefaultTemperature:Int64 = 23
let LyEditStepViewModelDefaultDuration:Int64 = 180
let LyEditStepViewModelDefaultAgitationDuration:Int64 = 5
let LyEditStepViewModelDefaultAgitationFrequency:Int64 = 60

class LyEditStepViewModel: NSObject {
    
    var model:LyStep!
    
    let stepName = MutableProperty<String>("")
    let stepDescription = MutableProperty<String>("")
    let temperatureCelcius = MutableProperty<Int64>(0)
    let duration = MutableProperty<Int64>(0)
    let agitationDuration = MutableProperty<Int64>(0)
    let agitationFrequency = MutableProperty<Int64>(0)
    
    let temperatureString = MutableProperty<String>("")
    let durationString = MutableProperty<String>("")
    let agitationDurationString = MutableProperty<String>("")
    let agitationFrequencyString = MutableProperty<String>("")
    
    init(model:LyStep) {
        super.init()
        self.model = model
        
        //init
        stepName <~ ConstantProperty(self.model.name ?? "")
        stepDescription <~ ConstantProperty(model.blurb ?? "")
        temperatureCelcius <~ ConstantProperty(model.temperatureC ?? LyEditStepViewModelDefaultTemperature)
        duration <~ ConstantProperty(model.duration ?? LyEditStepViewModelDefaultDuration)
        agitationDuration <~ ConstantProperty(model.agitationDuration ?? LyEditStepViewModelDefaultAgitationDuration)
        agitationFrequency <~ ConstantProperty(model.agitationFrequency ?? LyEditStepViewModelDefaultAgitationFrequency)
        
        temperatureString <~ temperatureCelcius.producer.map({"\($0)℃"})
        durationString <~ duration.producer.map({
            let minutes = $0 / 60
            let seconds = $0 % 60
            return String(format: "%d:%02d", minutes,seconds)
        })
        agitationDurationString <~ agitationDuration.producer.map({"Agitate for \($0)s"})
        agitationFrequencyString <~ agitationFrequency.producer.map({"Agitate every \($0)s"})
        
        
        
        stepName.producer.startWithNext { [unowned self] in
            self.model.name = $0
        }
        
        stepDescription.producer.startWithNext { [unowned self] in
            self.model.blurb = $0
        }
        
        temperatureCelcius.producer.startWithNext { [unowned self] in
            self.model.temperatureC = $0
        }
        
        duration.producer.startWithNext { [unowned self] in
            self.model.duration = $0
        }
        
        agitationDuration.producer.startWithNext { [unowned self] in
            self.model.agitationDuration = $0
        }
        
        agitationFrequency.producer.startWithNext { [unowned self] in
            self.model.agitationFrequency = $0
        }
    }
}
