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
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var protocols = [Protocol]()
    var formatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    let today = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fetchProtocol()
        protocols = Protocol.fetchProtocols(managedObjectContext, today: self.today)
        
        protocolTableView.dataSource = self
        protocolTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        protocols = Protocol.fetchProtocols(managedObjectContext, today: self.today)
        protocolTableView.reloadData()
        self.updateActualValueLabel()
        
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Phe-Grenzwert", message: "Geben Sie Ihr täglicher Phenylalanin-Grenzwert ein", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Speichern", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            if !firstTextField.text!.isEmpty {
                //print("juhee")
                self.defaults.setInteger(Int(firstTextField.text!)!, forKey: "pheLimit")
                self.updateActualValueLabel()
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Aktuell gesetzt: " + String(self.defaults.integerForKey("pheLimit"))
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protocolCell", forIndexPath: indexPath) as! DayProtocolTableViewCell
        
        // Configure the cell...
        let aProtocol = protocols[indexPath.row]
        cell.productName.text = aProtocol.product?.name
        cell.amount.text = "\(aProtocol.amount!) \(aProtocol.product!.baseUnit!)"
        cell.calculatedPheValue.text = self.formatter.stringFromNumber(calculatePheValue(aProtocol))
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return protocols.count
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let protocolToEdit = protocols[indexPath.row]
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
            let alertController = UIAlertController(title: "Neue Mengenangabe", message: "Geben Sie die neue Menge in ein", preferredStyle: .Alert)
            
            let saveAction = UIAlertAction(title: "Speichern", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
                
                let firstTextField = alertController.textFields![0] as UITextField
                protocolToEdit.amount = Double(firstTextField.text!)
                
                self.protocolTableView.reloadData()
                self.updateActualValueLabel()
            })
            
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
                textField.placeholder = "Aktuell gesetzt: " + String(protocolToEdit.amount!)
                textField.keyboardType = UIKeyboardType.NumberPad
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        edit.backgroundColor = UIColor.darkGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Löschen") { action, index in
            
            // Delete it from the managedObjectContext
            self.managedObjectContext.deleteObject(protocolToEdit)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
            // Refresh the table view to indicate that it's deleted
            self.protocols = Protocol.fetchProtocols(self.managedObjectContext, today: self.today)
            
            // Delete the row from the data source
            self.protocolTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.updateActualValueLabel()
            
            }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    
    func updateActualValueLabel(){
        
        var actualValue = Double()
        
        for aProtocol in self.protocols{
            actualValue += calculatePheValue(aProtocol)
        }
        
        if actualValue > Double(self.defaults.integerForKey("pheLimit")){
            self.actualValueLabel.textColor = UIColor.redColor()
        } else {
            self.actualValueLabel.textColor = UIColor.greenColor()
        }
        
        self.actualValueLabel.text = self.formatter.stringFromNumber(actualValue)
        
    }
    
    func calculatePheValue(aProtocol: Protocol) -> Double {
        return Double(aProtocol.amount!) * (Double((aProtocol.product?.pheValue)!) / Double((aProtocol.product?.basicAmount)!))
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showProtocolView" {
            
            // Get the new view controller using segue.destinationViewController.
            let viewController: ProtocolViewController = segue.destinationViewController as! ProtocolViewController
            
            // Pass the selected object to the new view controller.
            viewController.passedDefaults = self.defaults
        }
    }
}