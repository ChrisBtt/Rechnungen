//
//  RechnungenTVC.swift
//  Rechnungen
//
//  Created by Christoph Blattgerste on 04.10.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RechnungenTableViewController : UITableViewController {
    
    var monat : Monate!
    
    private var context : NSManagedObjectContext {
        return monat.managedObjectContext!
        
        
    }
    
    private lazy var rechnungen: NSFetchedResultsController = {
        // The fetch request defines the subset of objects to fetch
        let fetchRequest = NSFetchRequest(entityName: "Rechnungen")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "verwendung", ascending: true) ]
        // Create the fetched results controller with the fetch request
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        // The delegate can react to changes in the set of fetched objects
        resultsController.delegate = self
        return resultsController
    }()
    
    
//    unwind segue 
//    save context
//    expand context with a new entry
}

// MARK: - Fetched Results Controller Delegate

extension RechnungenTableViewController: NSFetchedResultsControllerDelegate {
    
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
