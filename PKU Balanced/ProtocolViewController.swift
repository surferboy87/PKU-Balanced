//
//  ProtocolViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 22.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProtocolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var protocolTableView: UITableView!
    
    // Retreive the managedObjectContext and numberFormatter from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let numberFormatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter

    let dateFormatter = NSDateFormatter()
    
    // CH date format
    let chDateFormatTemplate = NSDateFormatter.dateFormatFromTemplate("ddMMyyyy", options: 0, locale: NSLocale(localeIdentifier: "de-CH"))
    
    var protocolDataArray = [Protocol]()
    
    var dayProtocols: [String: [Protocol]] = Dictionary()
    
    var reverseSortedDayProtocolsKeys = [String]()
    
    // Passed from segue
    var passedDefaults: NSUserDefaults!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetching all protocols
        self.protocolDataArray = Protocol.fetchAllProtocols(self.managedObjectContext)
        
        // Set date format of the dateFormatter to CH
        self.dateFormatter.dateFormat = self.chDateFormatTemplate
        
        //Set up a dictionary with a formatted date (e.g. 24.06.2016) as key and each protocol with that date to an array
        for aProtocol in self.protocolDataArray {
            
            // Define the key
            let keyDate = self.dateFormatter.stringFromDate(aProtocol.date!)
        
            // If protocolArrayOfKey has a key keyDate, add aProtocol to the array, otherwise create a new key and add aProtocol
            if var protocolArrayOfKey = self.dayProtocols[keyDate] {
                protocolArrayOfKey.append(aProtocol)
                self.dayProtocols[keyDate] = protocolArrayOfKey
            } else {
                self.dayProtocols[keyDate] = [aProtocol]
            }
        }
        
        // Sort keys of the dayProtocols dictionary in store them in a new array
        let sortedDayProtocolsKeys = Array(self.dayProtocols.keys).sort()
        
        // Sort sortedDayProtocolsKeys array in revers order
        self.reverseSortedDayProtocolsKeys = sortedDayProtocolsKeys.reverse()
        
        self.protocolTableView.dataSource = self
        self.protocolTableView.delegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // Reload the table view
        self.protocolTableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return self.dayProtocols.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protocolCell", forIndexPath: indexPath) as! ProtocolTableViewCell
        
        // Get the key of the selected table row
        let key = self.reverseSortedDayProtocolsKeys[indexPath.row]
        
        // Calculate the phe value of that protocol
        let calculatedPheValue = self.calculateProtocolPheValue(self.dayProtocols[key]!)
        
        // Configure the cell...
        cell.protocolDate.text = key
        cell.pheValue.text = self.numberFormatter.stringFromNumber(calculatedPheValue)
        
        // Compare calculatedPheValue to the stored pheLimit in user defaults and coloring the text of the label
        if calculatedPheValue > self.passedDefaults.doubleForKey("pheLimit"){
            cell.pheValue.textColor = UIColor.redColor()
        } else {
            cell.pheValue.textColor = UIColor.greenColor()
        }
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Sum up all the phe value of a protocol in a protocol array
    func calculateProtocolPheValue(someProtocols: [Protocol]) -> Double {
        
        var pheValue = 0.0
        
        for aProtocol in someProtocols {
            let base = Double((aProtocol.product?.pheValue)!) / Double((aProtocol.product?.basicAmount)!)
            pheValue += Double(aProtocol.amount!) * base
        }
      return pheValue
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller
        let viewController: ProtocolDetailViewController = segue.destinationViewController as! ProtocolDetailViewController
        
        // Pass the selected object to the new view controller.
        let key = self.reverseSortedDayProtocolsKeys[self.protocolTableView.indexPathForSelectedRow!.row]
        viewController.passedProtocols = self.dayProtocols[key]
        viewController.passedProtocolDate = key
    }
    

}
