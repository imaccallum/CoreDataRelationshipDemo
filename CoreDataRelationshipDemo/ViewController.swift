//
//  ViewController.swift
//  CoreDataRelationshipDemo
//
//  Created by Ian MacCallum on 1/30/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ViewController: UITableViewController {
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        fetchedResultsController?.performFetch(nil)
    }
    
    func fetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
}

// MARK: UITableView Data Source & Delegate
extension ViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as UITableViewCell
        let category = fetchedResultsController?.objectAtIndexPath(indexPath) as? Category
        
        cell.textLabel?.text = category?.name

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TaskSegue" {
            let destination = segue.destinationViewController as TaskViewController
            let indexPath = self.tableView?.indexPathForCell(sender as UITableViewCell)
            destination.category = fetchedResultsController?.objectAtIndexPath(indexPath!) as? Category
        }
    }
}

// MARK: IBActions
extension ViewController: UIAlertViewDelegate {
    
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
    }

    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "Enter a name:", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler() { textField in
            textField.placeholder = "Category"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { action in }
        let save = UIAlertAction(title: "Save", style: .Default) { action in
            let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: self.managedObjectContext!) as Category
            newCategory.name = (alert.textFields as [UITextField])[0].text
            
            self.managedObjectContext?.save(nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        presentViewController(alert, animated: true) {}
    }
}

// MARK: NSFetchedResultsController Delegate
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete:
            managedObjectContext?.deleteObject(fetchedResultsController?.objectAtIndexPath(indexPath) as Category)
            managedObjectContext?.save(nil)
        case .Insert:
            break
        case .None:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case NSFetchedResultsChangeType.Move:
            break
        case NSFetchedResultsChangeType.Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
}