//
//  Protocol.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 14.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import Foundation
import CoreData


class Protocol: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, inputAmount: NSNumber, inputProduct: Product) -> Protocol {
        let newProtocol = NSEntityDescription.insertNewObjectForEntityForName("Protocol", inManagedObjectContext: moc) as! Protocol
        
        newProtocol.date = NSDate()
        newProtocol.amount = inputAmount
        newProtocol.product = inputProduct
        
        return newProtocol
    }
    
    
    class func fetchProtocols(moc: NSManagedObjectContext, today: NSDate) -> Array<Protocol> {
        let fetchRequest = NSFetchRequest(entityName: "Protocol")
        
        // Create a sort descriptor object that sorts on the "productName" property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)

        // get the current calendar
        let calendar = NSCalendar.currentCalendar()
        // get the start of the day of the selected date
        let startDate = calendar.startOfDayForDate(today)
        // get the start of the day after the selected date
        let endDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: startDate, options: NSCalendarOptions())!
        // create a predicate to filter between start date and end date
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate, endDate)
        
        fetchRequest.predicate = predicate
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as! [Protocol]
            let protocols = fetchResults
            return protocols
        } catch {
            fatalError("Failed to fetch protocols: \(error)")
        }
    }
    
    class func fetchAllProtocols(moc: NSManagedObjectContext) -> Array<Protocol> {
        let fetchRequest = NSFetchRequest(entityName: "Protocol")
        
        // Create a sort descriptor object that sorts on the "productName" property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as! [Protocol]
            let protocols = fetchResults
            return protocols
        } catch {
            fatalError("Failed to fetch protocols: \(error)")
        }
    }
}
