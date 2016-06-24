//
//  HomeViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 11.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var actualValueLabel: UILabel!
    @IBOutlet weak var protocolTableView: UITableView!
    
    // Retreive the managedObjectContext and numberFormatter from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let formatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter
    
    // Use of NSUserDefaults to store the personal Phe-Limit
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Set the background color for a invalid input field
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    // Get the actual date
    let today = NSDate()
    
    var protocols = [Protocol]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetching the stored protocols
        self.protocols = Protocol.fetchProtocols(managedObjectContext, today: self.today)
        
        self.protocolTableView.dataSource = self
        self.protocolTableView.delegate = self
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // When the View will appear, fetch the protocols and update the actual phe-value label
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.protocols = Protocol.fetchProtocols(managedObjectContext, today: self.today)
        self.protocolTableView.reloadData()
        
        self.updateActualValueLabel()
        
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protocolCell", forIndexPath: indexPath) as! DayProtocolTableViewCell
        
        // Configure the cell...
        let aProtocol = protocols[indexPath.row]
        
        cell.productName.text = aProtocol.product?.name
        cell.amount.text = "\(aProtocol.amount!) \(aProtocol.product!.baseUnit!)"
        cell.calculatedPheValue.text = self.formatter.stringFromNumber(self.calculatePheValue(aProtocol))
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the number of protocols
        return self.protocols.count
    }
    
    
    // MARK: UITableViewDelegate
    
    // Set possible options if table row is swiped to left
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Get the protocol which was selected in the table
        let protocolToEdit = self.protocols[indexPath.row]
        
        // Define the edit button action
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
            // Create a alertController to show the action
            let alertController = UIAlertController(title: "Neue Mengenangabe", message: "Geben Sie die neue Menge in ein", preferredStyle: .Alert)
            
            // Define the saveAction
            let saveAction = UIAlertAction(title: "Speichern", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
                
                // Get the textfield from alertController
                let firstTextField = alertController.textFields![0] as UITextField
                
                // Set the new amount (if set) from the entered text
                if (!firstTextField.text!.isEmpty) {
                    protocolToEdit.amount = Double(firstTextField.text!)
                }
                
                // Update the table view and the actual phe value label
                self.protocolTableView.reloadData()
                self.updateActualValueLabel()
            })
            
            // Define the cancelAction
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
            // Set message and defaults on the alertController
            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
                textField.placeholder = "Aktuell gesetzt: " + String(protocolToEdit.amount!)
                textField.keyboardType = UIKeyboardType.NumberPad
            }
            
            // Add the actions to the alertController
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        // Set the backgroundColor of the edit "button"
        edit.backgroundColor = UIColor.darkGrayColor()
        
        // Define the deleteAction
        let delete = UITableViewRowAction(style: .Normal, title: "Löschen") { action, index in
            
            // Delete protocolToEdit from the managedObjectContext
            self.managedObjectContext.deleteObject(protocolToEdit)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
            // Refresh the table view to indicate that it's deleted
            self.protocols = Protocol.fetchProtocols(self.managedObjectContext, today: self.today)
            
            // Delete the row from the data source and update the actual phe value label
            self.protocolTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.updateActualValueLabel()
            
            }
        
        // Set the backgroundColor of the delete "button"
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    
    // Updates the phe value label
    func updateActualValueLabel(){
        
        var actualValue = Double()
        
        // Sum up the calculated phe values of each product in protocols
        for aProtocol in self.protocols{
            actualValue += calculatePheValue(aProtocol)
        }
        
        // Set text color based on the phe limit and calculated phe value (red if calculated phe value > phe limit,
        // green if calculated phe value <= phe limit)
        if actualValue > Double(self.defaults.integerForKey("pheLimit")){
            self.actualValueLabel.textColor = UIColor.redColor()
        } else {
            self.actualValueLabel.textColor = UIColor.greenColor()
        }
        
        // Format the number for presentation
        self.actualValueLabel.text = self.formatter.stringFromNumber(actualValue)
        
    }
    
    
    // Calculates the phe value of a protocol
    func calculatePheValue(aProtocol: Protocol) -> Double {
        return Double(aProtocol.amount!) * (Double((aProtocol.product?.pheValue)!) / Double((aProtocol.product?.basicAmount)!))
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showProtocolView" {
            
            // Get the new view controller
            let viewController: ProtocolViewController = segue.destinationViewController as! ProtocolViewController
            
            // Pass the selected object to the new view controller.
            viewController.passedDefaults = self.defaults
        }
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        
        // Create a alertController to show the action
        let alertController = UIAlertController(title: "Phe-Grenzwert", message: "Geben Sie Ihr täglicher Phenylalanin-Grenzwert ein", preferredStyle: .Alert)
        
        // Define the saveAction
        let saveAction = UIAlertAction(title: "Speichern", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            // Set the new phe limit (if set) from the entered text and update phe value label
            if (!firstTextField.text!.isEmpty) {
                self.defaults.setInteger(Int(firstTextField.text!)!, forKey: "pheLimit")
                self.updateActualValueLabel()
            }
            
        })
        
        // Define the cancelAction
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        // Set message and defaults on the alertController
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Aktuell gesetzt: " + String(self.defaults.integerForKey("pheLimit"))
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        // Add actions to the alertController
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}