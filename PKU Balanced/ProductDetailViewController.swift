//
//  ProductDetailViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 18.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UITextFieldDelegate {
    
    var receivedProduct: Product!
    
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

    
    let backgroundColorInputFailure = UIColor.redColor().colorWithAlphaComponent(0.3)
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBAction func addToProtocol(sender: UIButton) {
        if self.inputAmount.text!.isEmpty {
            self.inputAmount.backgroundColor = self.backgroundColorInputFailure
        } else {
            Protocol.createInManagedObjectContext(managedObjectContext, inputAmount: (self.inputAmount.text! as NSString).integerValue, inputProduct: self.receivedProduct)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            self.inputAmount.backgroundColor = UIColor.whiteColor()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func inputValueChange(sender: UITextField) {
        if sender.text!.characters.count > 0 {
            self.updatePheValueLabel(Double(sender.text!)!)
        } else {
            self.updatePheValueLabel(0)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.productName.text = self.receivedProduct.name
        self.inputAmount.delegate = self
        self.inputAmount.text = String(self.receivedProduct.basicAmount!)
        self.inputAmount.becomeFirstResponder()
        self.baseUnit.text = self.receivedProduct.baseUnit!
        self.updatePheValueLabel(Double(self.inputAmount.text!)!)
        
        self.additionalInfo.text = "Informationen bezogen auf \(self.receivedProduct.basicAmount!) \(self.receivedProduct.baseUnit!)"
        
        self.energyKj.text = getDashOrNumber(self.receivedProduct.energyKj!)
        self.energyKcal.text = getDashOrNumber(self.receivedProduct.energyKcal!)
        self.protein.text = getDashOrNumber(self.receivedProduct.protein!)
        self.carbohydrates.text = getDashOrNumber(self.receivedProduct.carbohydrates!)
        self.sugar.text = getDashOrNumber(self.receivedProduct.sugar!)
        self.fat.text = getDashOrNumber(self.receivedProduct.fat!)
        self.saturates.text = getDashOrNumber(self.receivedProduct.saturates!)
        self.dietaryFibre.text = getDashOrNumber(self.receivedProduct.dietaryFibre!)
        self.salt.text = getDashOrNumber(self.receivedProduct.salt!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func getDashOrNumber(number: NSNumber) -> String {
        if Double(number) > 0.0 {
            return String(number)
        } else {
            return "-"
        }
    }
    
    
    func updatePheValueLabel(value: Double){
        self.calculatedPheValue.text = formatter.stringFromNumber(self.calculatePheValue(value))
    }
    
    func calculatePheValue(input: Double) -> Double {
        return input * (Double((self.receivedProduct.pheValue)!) / Double((self.receivedProduct.basicAmount)!))
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
