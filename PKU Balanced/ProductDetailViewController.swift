//
//  ProductDetailViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 18.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UITextFieldDelegate {
    
    // Retreive the managedObjectContext and numberFormatter from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let formatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var baseUnit: UILabel!
    @IBOutlet weak var calculatedPheValue: UILabel!
    @IBOutlet weak var addToProtocolButton: UIButton!
    
    @IBOutlet weak var additionalInfo: UILabel!
    
    @IBOutlet weak var energyKj: UILabel!
    @IBOutlet weak var energyKcal: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var carbohydrates: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var saturates: UILabel!
    @IBOutlet weak var dietaryFibre: UILabel!
    @IBOutlet weak var salt: UILabel!

    // Set the background color for a invalid input field
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    // Passed values
    var passedProduct: Product!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fill out all values of the view based on the selected product
        self.productName.text = self.passedProduct.name
        self.inputAmount.delegate = self
        self.inputAmount.text = String(self.passedProduct.basicAmount!)
        self.inputAmount.becomeFirstResponder()
        self.baseUnit.text = self.passedProduct.baseUnit!
        self.updatePheValueLabel(Double(self.inputAmount.text!)!)
        
        self.additionalInfo.text = "Informationen bezogen auf \(self.passedProduct.basicAmount!) \(self.passedProduct.baseUnit!)"
        
        self.energyKj.text = getDashOrNumber(self.passedProduct.energyKj!)
        self.energyKcal.text = getDashOrNumber(self.passedProduct.energyKcal!)
        self.protein.text = getDashOrNumber(self.passedProduct.protein!)
        self.carbohydrates.text = getDashOrNumber(self.passedProduct.carbohydrates!)
        self.sugar.text = getDashOrNumber(self.passedProduct.sugar!)
        self.fat.text = getDashOrNumber(self.passedProduct.fat!)
        self.saturates.text = getDashOrNumber(self.passedProduct.saturates!)
        self.dietaryFibre.text = getDashOrNumber(self.passedProduct.dietaryFibre!)
        self.salt.text = getDashOrNumber(self.passedProduct.salt!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Touchevents
    
    // Used to end editing and hide Keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    // Returns the number or a dash for representing
    func getDashOrNumber(number: NSNumber) -> String {
        if Double(number) > 0.0 {
            return String(number)
        } else {
            return "-"
        }
    }
    
    
    // Returns the updated phe vlaue as String
    func updatePheValueLabel(value: Double){
        self.calculatedPheValue.text = formatter.stringFromNumber(self.calculatePheValue(value))
    }
    
    
    // Calculates the phe value of a double value
    func calculatePheValue(input: Double) -> Double {
        return input * (Double((self.passedProduct.pheValue)!) / Double((self.passedProduct.basicAmount)!))
    }
    
    // Adds the product to the protocol
    @IBAction func addToProtocol(sender: UIButton) {
        
        // If inputAmount textfield is not empty, create a new protocol
        if self.inputAmount.text!.isEmpty {
            self.inputAmount.backgroundColor = self.backgroundColorInputFailure
        } else {
            Protocol.createInManagedObjectContext(managedObjectContext, inputAmount: (self.inputAmount.text! as NSString).integerValue, inputProduct: self.passedProduct)
            self.inputAmount.backgroundColor = UIColor.whiteColor()
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // Update actual phe value based on the amount input field
    @IBAction func inputValueChange(sender: UITextField) {
        if sender.text!.characters.count > 0 {
            self.updatePheValueLabel(Double(sender.text!)!)
        } else {
            self.updatePheValueLabel(0)
        }
        
    }

}
