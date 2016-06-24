//
//  Product+CoreDataProperties.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 17.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var baseUnit: String?
    @NSManaged var basicAmount: NSNumber?
    @NSManaged var carbohydrates: NSNumber?
    @NSManaged var dietaryFibre: NSNumber?
    @NSManaged var energyKcal: NSNumber?
    @NSManaged var energyKj: NSNumber?
    @NSManaged var fat: NSNumber?
    @NSManaged var name: String?
    @NSManaged var pheValue: NSNumber?
    @NSManaged var protein: NSNumber?
    @NSManaged var salt: NSNumber?
    @NSManaged var saturates: NSNumber?
    @NSManaged var sugar: NSNumber?
    @NSManaged var protocols: NSSet?

}
