//
//  LyTimerViewController.swift
//  Swift-C41
//
//  Created by ly on 16/8/3.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LyTimerViewController: UIViewController {

    var viewModel: LyTimerViewModel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var stepNameLabel: UILabel!
    @IBOutlet weak var nextStepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = viewModel.recipeName.value
        
        self.stepNameLabel.rac_text <~ self.viewModel.currentStepString
        self.timeRemainingLabel.rac_text <~ self.viewModel.timeRemainingString
        self.nextStepLabel.rac_text <~ self.viewModel.nextStepString
        
        self.navigationItem.rac_rightBarButtonItem <~ self.viewModel.running.producer.map({ [unowned self] (running) -> UIBarButtonItem in
            if running {
                return UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: #selector(LyTimerViewController.pause))
            }
            return UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: #selector(LyTimerViewController.resume))
        })
        
        self.viewModel.complete.producer.startWithNext { (complete) in
            if complete
            {
                let alert = UIAlertController(title: "Recipe Complete", message: "Your film has been developed.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler:  { [unowned self] (action) in
                    self.dismiss()
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Configure subviews
        self.timeRemainingLabel.layer.cornerRadius = CGRectGetHeight(self.timeRemainingLabel.frame) / 2.0
        self.timeRemainingLabel.layer.borderWidth = 5.0
        self.timeRemainingLabel.layer.borderColor = UIColor(hexString: "DE9726").CGColor
        self.timeRemainingLabel.textColor = UIColor(hexString: "522404")
    }
    
    func pause() {
        self.viewModel.pause()
    }
    
    func resume() {
        self.viewModel.resume()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismiss()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
