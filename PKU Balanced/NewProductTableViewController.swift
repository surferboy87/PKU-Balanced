//
//  NewProductTableViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 11.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit
import CoreData

class NewProductTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var newProductTableView: UITableView!
    
    // Mandatory textfields
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var basicAmount: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var pheValue: UITextField!
    
    // Optional textfields
    @IBOutlet weak var energyKj: UITextField!
    @IBOutlet weak var energyKcal: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var carbohydrates: UITextField!
    @IBOutlet weak var sugar: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var saturates: UITextField!
    @IBOutlet weak var dietaryFibre: UITextField!
    @IBOutlet weak var salt: UITextField!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let pickerData = ["Gramm", "Mililiter", "Stück", "Portion"]
    
    // Set the background color for a invalid input field
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    var alert:UIAlertController!
    var pickedUnit = "g"
    
    // Bool to indicate if in edit mode
    var editMode = false
    
    // Passed product from segue
    var passedProduct: Product!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitPicker.dataSource = self
        unitPicker.delegate = self
        
        // Check if in edit mode
        if self.editMode {
            
            // Fill all fields in view with the stored values
            self.productName.text = self.passedProduct.name
            self.basicAmount.text = String(self.passedProduct.basicAmount!)
            self.unitPicker.selectRow(self.getIndexInPickerData(self.passedProduct.baseUnit!), inComponent: 0, animated: true)
            self.pheValue.text = String(self.passedProduct.pheValue!)
            
            self.energyKj.text = String(self.passedProduct.energyKj!)
            self.energyKcal.text = String(self.passedProduct.energyKcal!)
            self.protein.text = String(self.passedProduct.protein!)
            self.carbohydrates.text = String(self.passedProduct.carbohydrates!)
            self.sugar.text = String(self.passedProduct.sugar!)
            self.fat.text = String(self.passedProduct.fat!)
            self.saturates.text = String(self.passedProduct.saturates!)
            self.dietaryFibre.text = String(self.passedProduct.dietaryFibre!)
            self.salt.text = String(self.passedProduct.salt!)
            
        } else {
            
            self.productName.becomeFirstResponder()
            self.unitPicker.dataSource = self
            self.unitPicker.delegate = self
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in a section
        switch section {
        case 0:
            return 3
        case 1:
            return 9
        default:
            assert(false, "section \(section)")
            return 0
        }
    }
    
    // MARK: - Picker view data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return the number of rows
        return self.pickerData.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        // Set picketUnit to the abbreviated string
        switch self.pickerData[row] {
        case "Gramm":
            self.pickedUnit = "g"
        case "Mililiter":
            self.pickedUnit = "ml"
        case "Stück":
            self.pickedUnit = "Stk"
        case "Portion":
            self.pickedUnit = "p"
        default:
            self.pickedUnit = "g"
        }
    }
    
    // Get array index of a given picker data string
    func getIndexInPickerData(unit: String) -> Int {
        switch unit {
        case "g":
            return self.pickerData.indexOf("Gramm")!
        case "ml":
            return self.pickerData.indexOf("Mililiter")!
        case "Stk":
            return self.pickerData.indexOf("Stück")!
        case "p":
            return self.pickerData.indexOf("Portion")!
        default:
            return self.pickerData.indexOf("Gramm")!
        }
    }
    
    
    // Convert a text of a textfield to a double
    func getDoubleValueFromTextfield(textfield: UITextField) -> Double {
        return NSString(string: textfield.text!).doubleValue
    }
    
    
    // Checks if the new product can be saved or mandatory fields missing
    func checkMandatoryFields() -> Bool {
        
        // Madatory textfields in array
        let mandatoryTextfields = [self.productName, self.basicAmount, self.pheValue]
        
        // Bool to indicate if it can be saved
        var canBeSaved = true
        
        // Check mandatory textfields if not empty
        for field in mandatoryTextfields {
            if (field.text!.isEmpty) {
                
                // if empty, set backgroundcolor red
                field.backgroundColor = self.backgroundColorInputFailure
                canBeSaved = false
            } else {
                field.backgroundColor = UIColor.whiteColor()
            }
        }
        
        return canBeSaved
    }
    
    @IBAction func saveButtonAction(sender: UIBarButtonItem) {
        
        // Check if every mandatory field is set
        if self.checkMandatoryFields() {
            
            // Check if in edit mode
            if editMode {
                
                // Update passedProduct with new values
                self.passedProduct.name = self.productName.text
                self.passedProduct.basicAmount = getDoubleValueFromTextfield(self.basicAmount)
                self.passedProduct.baseUnit = self.pickedUnit
                self.passedProduct.pheValue = getDoubleValueFromTextfield(self.pheValue)
                
                self.passedProduct.energyKj = getDoubleValueFromTextfield(self.energyKj)
                self.passedProduct.energyKcal = getDoubleValueFromTextfield(self.energyKcal)
                self.passedProduct.protein = getDoubleValueFromTextfield(self.protein)
                self.passedProduct.carbohydrates = getDoubleValueFromTextfield(self.carbohydrates)
                self.passedProduct.sugar = getDoubleValueFromTextfield(self.sugar)
                self.passedProduct.fat = getDoubleValueFromTextfield(self.fat)
                self.passedProduct.saturates = getDoubleValueFromTextfield(self.saturates)
                self.passedProduct.dietaryFibre = getDoubleValueFromTextfield(self.dietaryFibre)
                self.passedProduct.salt = getDoubleValueFromTextfield(self.salt)
                
                self.editMode = false
                
            } else {
                
                // Create new product for core data
                let productStrings: [String: String] = [
                    "ProductName": self.productName.text!,
                    "BaseUnit": self.pickedUnit
                ]
                
                let productValues: [String: Double] = [
                    "BasicAmount": getDoubleValueFromTextfield(self.basicAmount),
                    "PheValue": getDoubleValueFromTextfield(self.pheValue),
                    "EnergyKj": getDoubleValueFromTextfield(self.energyKj),
                    "EnergyKcal": getDoubleValueFromTextfield(self.energyKcal),
                    "Protein": getDoubleValueFromTextfield(self.protein),
                    "Carbohydrates": getDoubleValueFromTextfield(self.carbohydrates),
                    "Sugar": getDoubleValueFromTextfield(self.sugar),
                    "Fat": getDoubleValueFromTextfield(self.fat),
                    "Saturates": getDoubleValueFromTextfield(self.saturates),
                    "DietaryFibre": getDoubleValueFromTextfield(self.dietaryFibre),
                    "Salt": getDoubleValueFromTextfield(self.salt)
                ]
                
                Product.createInManagedObjectContext(managedObjectContext, inputStrings: productStrings, inputValues: productValues)
            }
            
            // Save core data
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
