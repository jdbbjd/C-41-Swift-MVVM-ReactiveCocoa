//
//  LyDetailViewController.swift
//  Swift-C41
//
//  Created by ly on 16/8/3.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

enum LyDetailSection: Int {
    case LyDetailViewControllerInfoSection = 0,
    LyDetailViewControllerStepsSection,
    LyDetailViewControllerNumberOfSections
}

enum LyDetailRow: Int {
    case LyDetailViewControllerInfoNameRow = 0,
    LyDetailViewControllerInfoDescriptionRow,
    LyDetailViewControllerInfoFilmTypeRow,
    LyDetailViewControllerInfoNumberOfRows
}
    
class LyDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var viewModel:LyDetailViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = viewModel.recipeName.value
        self.startBtn.rac_enabled <~ viewModel.canStartTimer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return LyDetailSection.LyDetailViewControllerNumberOfSections.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case LyDetailSection.LyDetailViewControllerInfoSection.rawValue:
            return LyDetailRow.LyDetailViewControllerInfoNumberOfRows.rawValue
        case LyDetailSection.LyDetailViewControllerStepsSection.rawValue:
            return self.viewModel.numberOfSteps.value
        default:
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case LyDetailSection.LyDetailViewControllerInfoSection.rawValue:
            return "Info"
        default:
            return "Steps"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "detailCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellID)
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.selectionStyle = .None
        
        switch indexPath.section {
        case LyDetailSection.LyDetailViewControllerInfoSection.rawValue:
            cell?.detailTextLabel?.text = nil
            switch indexPath.row {
            case LyDetailRow.LyDetailViewControllerInfoNameRow.rawValue:
                cell!.textLabel!.rac_text <~ viewModel.recipeName
            case LyDetailRow.LyDetailViewControllerInfoDescriptionRow.rawValue:
                cell!.textLabel!.rac_text <~ viewModel.recipeDescription
            default:
                cell!.textLabel!.rac_text <~ viewModel.recipeFilmTypeString
            }
        default:
            cell?.textLabel?.text = viewModel.titleForStepAtIndex(indexPath.row)
            cell?.detailTextLabel?.text = viewModel.subtitleForStepAtIndex(indexPath.row)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == LyDetailSection.LyDetailViewControllerInfoSection.rawValue && indexPath.row == LyDetailRow.LyDetailViewControllerInfoDescriptionRow.rawValue {
            let description = viewModel.recipeDescription.value
            let rect = description.boundingRectWithSize(CGSizeMake(self.view.frame.width - 30, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
            
            return max(44, CGRectGetHeight(rect) + 23)
        }
        return 44
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != nil {
            if segue.identifier == "timer" {
                let timerVC = (segue.destinationViewController as! UINavigationController).topViewController as! LyTimerViewController
                timerVC.viewModel = self.viewModel.timerViewModel()
            }
        }
    }
    

}
