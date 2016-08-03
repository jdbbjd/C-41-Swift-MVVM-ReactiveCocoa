//
//  EditRecipeTableViewController.swift
//  Swift-C41
//
//  Created by ly on 16/8/2.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa

enum SectionCount:NSInteger {
    case LyEditRecipeViewControllerMetadataSection = 0,
    LyEditRecipeViewControllerFilmTypeSection,
    LyEditRecipeViewControllerStepsSection,
    LyEditRecipeViewControllerNumberOfSections
}

let TitleCellIdentifier = "title"
let DescriptionCellIdentifier = "description"
let StepCellIdentifier = "stepCell"
let AddStepCellIdentifier = "addStep"
let FilmTypeCellIdentifier = "filmType"

class LyEditRecipeTableViewController: UITableViewController {
    
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    
    var viewModel:LyEditRecipeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.editing = true

        self.navigationItem.rac_leftBarButtonItem <~ viewModel.inserting.producer.map({$0 ? self.navigationItem.leftBarButtonItem:nil})
        viewModel.name.producer.startWithNext { [unowned self] in
            self.title = $0
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func CancelBtnClick(sender: UIBarButtonItem) {
        self.viewModel.cancel()
        self.viewModel.willDismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func DoneBtnClick(sender: AnyObject) {
        self.viewModel.willDismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SectionCount.LyEditRecipeViewControllerNumberOfSections.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case SectionCount.LyEditRecipeViewControllerMetadataSection.rawValue:
            return 2
        case SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue:
            return 3
        case SectionCount.LyEditRecipeViewControllerStepsSection.rawValue:
            return self.viewModel.numberOfSteps() + 1
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier:String!
        
        if (indexPath.section == SectionCount.LyEditRecipeViewControllerMetadataSection.rawValue) {
            if (indexPath.row == 0) {
                cellIdentifier = TitleCellIdentifier
            } else {
                cellIdentifier = DescriptionCellIdentifier
            }
        } else if (indexPath.section == SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue) {
            cellIdentifier = FilmTypeCellIdentifier;
        } else {
            if (indexPath.row == self.viewModel.numberOfSteps()) {
                cellIdentifier = AddStepCellIdentifier
            } else {
                cellIdentifier = StepCellIdentifier
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        // Configure the cell...

        if (indexPath.section == SectionCount.LyEditRecipeViewControllerMetadataSection.rawValue) {
            if (indexPath.row == 0) {
                self.configureTitleCell(cell as! LyTextFieldCell, forIndexPath: indexPath)
            } else {
                self.configureDescriptionCell(cell as! LyTextFieldCell, forIndexPath: indexPath)
            }
        } else if (indexPath.section == SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue ) {
            self.configureFilmTypeCell(cell, forIndexPath: indexPath)
        } else {
            if (indexPath.row < self.viewModel.numberOfSteps()) {
                self.configureStepCell(cell, forIndexPath: indexPath)
            } else {
                // nop – configured in storyboard
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == SectionCount.LyEditRecipeViewControllerMetadataSection.rawValue) {
            return nil
        } else if (section == SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue) {
            return "Film Type"
        } else if (section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue) {
            return "Steps"
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue
            || indexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue) {
            let oldFilmType = self.viewModel.filmType.value
            self.viewModel.filmType <~ ConstantProperty(self.viewModel.filmTypeForSection(indexPath.row))
            if (oldFilmType != self.viewModel.filmType.value) {
                self.tableView.reloadRowsAtIndexPaths([indexPath, NSIndexPath(forRow: self.viewModel.sectionForFilmTpe(oldFilmType), inSection: SectionCount.LyEditRecipeViewControllerFilmTypeSection.rawValue)], withRowAnimation: .Fade)
            }
        } else if (indexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue) {
            if (indexPath.row < self.viewModel.numberOfSteps()) {
                // will be taken care of by storyboard
            } else {
                self.viewModel.addStep()
                tableView.reloadSections(NSIndexSet(index:SectionCount.LyEditRecipeViewControllerStepsSection.rawValue), withRowAnimation: .Automatic)
            }
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (indexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue) {
            return true
        } else {
            return false
        }
    }
    

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue) {
            if (indexPath.row == self.viewModel.numberOfSteps()) {
                return .Insert
            } else {
                return .Delete
            }
        } else {
            return .None
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.viewModel.removeStepAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            viewModel.addStep()
            tableView.reloadSections(NSIndexSet(index:SectionCount.LyEditRecipeViewControllerStepsSection.rawValue), withRowAnimation: .Automatic)
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.viewModel.moveStepFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return indexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue && indexPath.row < self.viewModel.numberOfSteps()
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section == SectionCount.LyEditRecipeViewControllerStepsSection.rawValue && proposedDestinationIndexPath.row < self.viewModel.numberOfSteps() {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != nil {
            if segue.identifier == "editStep" {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let editStepVC = segue.destinationViewController as! LyEditStepTableViewController
                editStepVC.viewModel = self.viewModel.editStepViewModelAtIndex(indexPath.row)
            }
        }
    }
 
    
    //MARK: - Cell Configuration
    
    func configureStepCell(cell:UITableViewCell, forIndexPath indexPath:NSIndexPath) {
        cell.textLabel!.text = self.viewModel.stepTitleAtIndex(indexPath.row)
    }
    
    func configureDescriptionCell(cell:LyTextFieldCell, forIndexPath indexPath:NSIndexPath) {
        cell.textField.text = self.viewModel.blurb.value
        self.viewModel.blurb <~ cell.textField.rac_text
    }
    
    func configureTitleCell(cell:LyTextFieldCell, forIndexPath indexPath:NSIndexPath) {
        cell.textField.text = self.viewModel.name.value
        self.viewModel.name <~ cell.textField.rac_text
//        cell.textField.rac_textSignal().takeUntil(cell.rac_prepareForReuseSignal) ~> RAC(self.viewModel, "name")
    }
    
    func configureFilmTypeCell(cell:UITableViewCell, forIndexPath indexPath:NSIndexPath) {
        
        let filmType = self.viewModel.filmTypeForSection(indexPath.row)
        let title = self.viewModel.titleForFilmTyle(filmType)
        cell.textLabel!.text = title
        let isFilmType = filmType == self.viewModel.filmType.value
        cell.accessoryType = isFilmType ? .Checkmark : .None
        cell.selectionStyle = .Blue
    }

}
