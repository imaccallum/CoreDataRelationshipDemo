//
//  AddTaskViewController.swift
//  CoreDataRelationshipDemo
//
//  Created by Ian MacCallum on 1/31/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
//    let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            // if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Player] {
            // categories = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Category]
            categories = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [Category] ?? [Category]()
        } catch _ {
            
        }
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: managedObjectContext!) as! Task
        newTask.title = titleTextField.text!
        newTask.category = categories[categoryPicker.selectedRowInComponent(0)]

        do {
            try managedObjectContext?.save()
        } catch _ {
        }
        dismissViewControllerAnimated(true) {}
    }
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {}
    }
}

extension AddTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    
}