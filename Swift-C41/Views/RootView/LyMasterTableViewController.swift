//
//  LyMasterTableViewController.swift
//  Swift-C41
//
//  Created by ly on 16/7/28.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class LyMasterTableViewController: UITableViewController {

    var viewModel:LyMasterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        viewModel = LyMasterViewModel(model:LyCoreDataStack.defaultStack.managedObjectContext)
      
        let subscriber = Observer<Int?, NoError>(next: {
            [unowned self] value in
                self.tableView.reloadData()
            })
        viewModel.updatedContentSignal.observe(subscriber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfItemsInSection(section)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Identifier = "masterCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifier)

        // Configure the cell...
        cell!.textLabel!.text = viewModel.titleAtIndexPath(indexPath)
        cell!.detailTextLabel!.text = viewModel.subtitleAtIndexPath(indexPath)

        return cell!
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            viewModel.deleteObjectAtIndexPath(indexPath)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing {
            self.performSegueWithIdentifier("editRecipe1", sender: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier != nil) {
            if segue.identifier == "editRecipe" {
                let editRecipeVC = (segue.destinationViewController as! UINavigationController).topViewController as! LyEditRecipeTableViewController
                editRecipeVC.viewModel = self.viewModel.editViewModelForNewRecipe()
            }else if segue.identifier == "showDetail"
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let detailVC = segue.destinationViewController as! LyDetailViewController
                detailVC.viewModel = self.viewModel.detailViewModelForIndexPath(indexPath)
            }else if segue.identifier == "editRecipe1"
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let editRecipeVC = (segue.destinationViewController as! UINavigationController).topViewController as! LyEditRecipeTableViewController
                editRecipeVC.viewModel = self.viewModel.editViewModelForIndexPath(indexPath)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "editRecipe1" {
            return tableView.editing
        }else
        {
            return !tableView.editing
        }
    }
}
