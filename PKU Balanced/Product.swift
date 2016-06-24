//
//  Product.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 14.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
class Product: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, inputStrings: Dictionary<String, String>, inputValues: Dictionary<String, Double>) -> Product {
        let newProduct = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: moc) as! Product
        
        newProduct.name = inputStrings["ProductName"]
        newProduct.basicAmount = inputValues["BasicAmount"]
        newProduct.baseUnit = inputStrings["BaseUnit"]
        newProduct.pheValue = inputValues["PheValue"]
        newProduct.energyKj = inputValues["EnergyKj"]
        newProduct.energyKcal = inputValues["EnergyKcal"]
        newProduct.protein = inputValues["Protein"]
        newProduct.carbohydrates = inputValues["Carbohydrates"]
        newProduct.sugar = inputValues["Sugar"]
        newProduct.fat = inputValues["Fat"]
        newProduct.saturates = inputValues["Saturates"]
        newProduct.dietaryFibre = inputValues["DietaryFibre"]
        newProduct.salt = inputValues["Salt"]
        
        return newProduct
    }
    
    class func fetchProduct(moc: NSManagedObjectContext) -> Array<Product> {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        
        // Create a sort descriptor object that sorts on the "productName" property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as! [Product]
            let products = fetchResults
            return products
        } catch {
            fatalError("Failed to fetch products: \(error)")
        }
    }

}
