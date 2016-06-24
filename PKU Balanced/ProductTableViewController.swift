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
    
    var selectedProductIndex: Int = 0
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    var productsDataArray = [Product]()
    
    var filteredArray = [Product]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchProduct()
        productsDataArray = Product.fetchProduct(managedObjectContext)
        
        productTableView.dataSource = self
        productTableView.delegate = self
        
        configureSearchController()
        
    }
    
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
        // Return the number of rows
        if self.shouldShowSearchResults {
            return self.filteredArray.count
        } else {
            return self.productsDataArray.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! ProductTableViewCell

        // Configure the cell...
        
        if self.shouldShowSearchResults {
            cell.productName.text = self.filteredArray[indexPath.row].name
        } else {
            cell.productName.text = self.productsDataArray[indexPath.row].name
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let product = productsDataArray[indexPath.row]
        self.selectedProductIndex = indexPath.row
        //print(product.name!)
    }

    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let productToEdit = productsDataArray[indexPath.row]
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
            
            self.performSegueWithIdentifier("showNewProductView", sender: productToEdit)
        }
        
        edit.backgroundColor = UIColor.darkGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Löschen") { action, index in
            
            // Delete it from the managedObjectContext
            self.managedObjectContext.deleteObject(productToEdit)
            
            // Refresh the table view to indicate that it's deleted
            self.productsDataArray = Product.fetchProduct(self.managedObjectContext)
            
            // Delete the row from the data source
            self.productTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
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
            
            // Get the new view controller using segue.destinationViewController.
            let viewController: ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
            
            // Pass the selected object to the new view controller.
            viewController.receivedProduct = self.productsDataArray[(self.productTableView.indexPathForSelectedRow?.row)!]
        }
        
        if segue.identifier == "showNewProductView" {

            if let product = sender as? Product {
                let viewController: NewProductTableViewController = segue.destinationViewController as! NewProductTableViewController
                viewController.passedProduct = product
                viewController.editMode = true
            }
                
            // Pass the selected object to the new view controller.
            
        }
    }
}
