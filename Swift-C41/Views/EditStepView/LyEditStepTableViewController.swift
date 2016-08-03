//
//  LyEditStepTableViewController.swift
//  Swift-C41
//
//  Created by ly on 16/8/3.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class LyEditStepTableViewController: UITableViewController {

    @IBOutlet weak var stepNameTextField: UITextField!
    @IBOutlet weak var stepDescriptionTextField: UITextField!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var agitationFrequencyLabel: UILabel!
    @IBOutlet weak var agitationDurationLabel: UILabel!
    
    @IBOutlet weak var temperatureStepper: UIStepper!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var agitationFrequencyStepper: UIStepper!
    @IBOutlet weak var agitationDurationStepper: UIStepper!
    let duration = MutableProperty<Int64>(0)
    var viewModel:LyEditStepViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stepNameTextField.text = viewModel.stepName.value
        stepDescriptionTextField.text = viewModel.stepDescription.value
        temperatureStepper.value = Double(viewModel.temperatureCelcius.value)
        durationStepper.value = Double(viewModel.duration.value)
        agitationDurationStepper.value = Double(viewModel.agitationDuration.value)
        agitationFrequencyStepper.value = Double(viewModel.agitationFrequency.value)
        
        viewModel.stepName.producer.startWithNext { [unowned self] in
            self.title = $0
        }
        
        self.temperatureLabel.rac_text <~ viewModel.temperatureString
        self.durationLabel.rac_text <~ viewModel.durationString
        self.agitationDurationLabel.rac_text <~ viewModel.agitationDurationString
        self.agitationFrequencyLabel.rac_text <~ viewModel.agitationFrequencyString
        
        viewModel.stepName <~ stepNameTextField.rac_text
        viewModel.stepDescription <~ stepDescriptionTextField.rac_text
  
        viewModel.temperatureCelcius <~ temperatureStepper.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().mapError { (error) -> NoError in
            return error as! NoError
            }.map { (stepper) -> Int64 in
                let step = stepper as! UIStepper
                return Int64(step.value)
        }
        
        viewModel.duration <~ durationStepper.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().mapError { (error) -> NoError in
            return error as! NoError
            }.map { (stepper) -> Int64 in
                let step = stepper as! UIStepper
                return Int64(step.value)
        }
        
        viewModel.agitationDuration <~ agitationDurationStepper.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().mapError { (error) -> NoError in
            return error as! NoError
            }.map { (stepper) -> Int64 in
                let step = stepper as! UIStepper
                return Int64(step.value)
        }
        
        viewModel.agitationFrequency <~ agitationFrequencyStepper.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().mapError { (error) -> NoError in
            return error as! NoError
        }.map { (stepper) -> Int64 in
            let step = stepper as! UIStepper
            return Int64(step.value)
        }
    }

}
