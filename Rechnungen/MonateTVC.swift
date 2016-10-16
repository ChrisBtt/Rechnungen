//
//  MonateTVC.swift
//  Rechnungen
//
//  Created by Christoph Blattgerste on 04.10.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MonateTableViewController : UITableViewController {
    
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private lazy var monate: NSFetchedResultsController = {
        // The fetch request defines the subset of objects to fetch
        let fetchRequest = NSFetchRequest(entityName: "Monate")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "monat", ascending: true) ]
        // Create the fetched results controller with the fetch request
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        // The delegate can react to changes in the set of fetched objects
        resultsController.delegate = self
        return resultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try monate.performFetch()
        } catch {
            print("Failed fetching objects: \(error)")
        }
    }
    
//    add month via AlertController
    
    @IBAction func addMonat() {
        let alertController = UIAlertController(title: "neuerMonat", message: "Hier den neuen Monat eingeben ...", preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Aktuell", style: .Cancel, handler: {(alert: UIAlertAction!)
            in
            let newMonth = NSEntityDescription.insertNewObjectForEntityForName("Monate", inManagedObjectContext: self.context) as! Monate
            newMonth.monat = NSDate()
            })
        alertController.addAction(action1)
        let action2 = UIAlertAction(title: "Eingabe", style: .Default, handler: {(alert: UIAlertAction!) in
            let newMonth = NSEntityDescription.insertNewObjectForEntityForName("Monate", inManagedObjectContext: self.context) as! Monate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            newMonth.monat = dateFormatter.dateFromString(alertController.textFields![0].text!)
            })
        alertController.addAction(action2)
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Month"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
        // add prepareForSegue method
        // change actual month name to german 
    
}


//  Table View Extension

extension MonateTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monate.sections![section].numberOfObjects
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return monate.sections!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MonateCell", forIndexPath: indexPath)
        let month = monate.sections![indexPath.section].objects![indexPath.row] as! Monate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        cell.textLabel!.text = dateFormatter.stringFromDate(month.monat!)
        return cell
    }
}

//  NSFetchedResultsControllerDelegate extension

extension MonateTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type) {
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation:.Automatic)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
            }
        case .Update, .Move where newIndexPath == indexPath:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
            }
        case .Move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath where newIndexPath != indexPath {
                tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch(type) {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
