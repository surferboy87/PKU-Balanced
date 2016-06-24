//
//  Protocol+CoreDataProperties.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 22.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Protocol {

    @NSManaged var amount: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var product: Product?

}
