//
//  ProductTableViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 11.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet var productTableView: UITableView!
    
    // Set the background color for a invalid input field
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    var productsDataArray = [Product]()
    
    var filteredArray = [Product]()
    
    // Bool to indicate if in search mode
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var selectedProductIndex: Int = 0
    
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetching the stored Products
        self.productsDataArray = Product.fetchProduct(managedObjectContext)
        
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        
        // Configure the search controller
        self.configureSearchController()
        
    }
    
    
    // When the View will appear, fetch the products
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        productsDataArray = Product.fetchProduct(managedObjectContext)
        productTableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the number of products and if in search mode
        if self.shouldShowSearchResults {
            return self.filteredArray.count
        } else {
            return self.productsDataArray.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! ProductTableViewCell

        // Configure the cell... depending if in search mode
        
        if self.shouldShowSearchResults {
            cell.productName.text = self.filteredArray[indexPath.row].name
        } else {
            cell.productName.text = self.productsDataArray[indexPath.row].name
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let product = productsDataArray[indexPath.row]
//        self.selectedProductIndex = indexPath.row
//        //print(product.name!)
//    }

    // MARK: UITableViewDelegate
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Set possible options if table row is swiped to left
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Get the product which was selected in the table
        let productToEdit = productsDataArray[indexPath.row]
        
        // Define the edit button action
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
            // Show the NewProductTableViewController with the selected product as sender
            self.performSegueWithIdentifier("showNewProductView", sender: productToEdit)
        }
        
        // Set the backgroundColor of the edit "button"
        edit.backgroundColor = UIColor.darkGrayColor()
        
        // Define the deleteAction
        let delete = UITableViewRowAction(style: .Normal, title: "Löschen") { action, index in
            
            // Delete it from the managedObjectContext
            self.managedObjectContext.deleteObject(productToEdit)
            
            // Refresh the table view to indicate that it's deleted
            self.productsDataArray = Product.fetchProduct(self.managedObjectContext)
            
            // Delete the row from the data source
            self.productTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
        // Set the backgroundColor of the delete "button"
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    
    // MARK: - Search
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Produkt Suche..."
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        self.productTableView.tableHeaderView = self.searchController.searchBar
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.shouldShowSearchResults = true
        self.productTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.shouldShowSearchResults = false
        self.productTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !self.shouldShowSearchResults {
            self.shouldShowSearchResults = true
            self.productTableView.reloadData()
        }
        
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        
        // Filter the data array and get only those products that match the search text.
        self.filteredArray = self.productsDataArray.filter({ (product) -> Bool in
            let productName: NSString = product.name!
            
            return (productName.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        self.productTableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showProductDetailView" {
            
            // Get the new view controller
            let viewController: ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
            
            // Pass the selected object to the new view controller.
            viewController.passedProduct = self.productsDataArray[(self.productTableView.indexPathForSelectedRow?.row)!]
        }
        
        
        if segue.identifier == "showNewProductView" {

            if let product = sender as? Product {
                
                // Get the new view controller
                let viewController: NewProductTableViewController = segue.destinationViewController as! NewProductTableViewController
                
                // Pass the selected object to the new view controller.
                viewController.passedProduct = product
                viewController.editMode = true
            }
        }
    }
}
