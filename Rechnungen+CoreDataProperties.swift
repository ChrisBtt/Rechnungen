//
//  Rechnungen+CoreDataProperties.swift
//  Rechnungen
//
//  Created by Christoph Blattgerste on 04.10.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Rechnungen {

    @NSManaged var betrag: NSNumber?
    @NSManaged var verwendung: String?
    @NSManaged var monat: NSManagedObject?

}
