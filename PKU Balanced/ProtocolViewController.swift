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
    
    var protocolDataArray = [Protocol]()
    let dateFormatter = NSDateFormatter()
    let chDateFormatTemplate = NSDateFormatter.dateFormatFromTemplate("ddMMyyyy", options: 0, locale: NSLocale(localeIdentifier: "de-CH"))
    var numberFormatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter
    
    var dayProtocols: [String: [Protocol]] = Dictionary()
    var reverseSortedDayProtocolsKeys = [String]()
    
    var passedDefaults: NSUserDefaults!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.protocolDataArray = Protocol.fetchAllProtocols(self.managedObjectContext)
        self.dateFormatter.dateFormat = self.chDateFormatTemplate
        
        for aProtocol in protocolDataArray {
            let keyDate = self.dateFormatter.stringFromDate(aProtocol.date!)

            if var protocolArrayOfKey = self.dayProtocols[keyDate] {
                protocolArrayOfKey.append(aProtocol)
                self.dayProtocols[keyDate] = protocolArrayOfKey
            } else {
                self.dayProtocols[keyDate] = [aProtocol]
            }
        }
        
        let sortedDayProtocolsKeys = Array(self.dayProtocols.keys).sort()
        self.reverseSortedDayProtocolsKeys = sortedDayProtocolsKeys.reverse()
        
        self.protocolTableView.dataSource = self
        self.protocolTableView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
        return dayProtocols.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protocolCell", forIndexPath: indexPath) as! ProtocolTableViewCell
        
        
        let key = self.reverseSortedDayProtocolsKeys[indexPath.row]
        let calculatedPheValue = self.calculateProtocolPheValue(self.dayProtocols[key]!)
        
        // Configure the cell...
        cell.protocolDate.text = key
        cell.pheValue.text = self.numberFormatter.stringFromNumber(calculatedPheValue)
        
        if calculatedPheValue > self.passedDefaults.doubleForKey("pheLimit"){
            cell.pheValue.textColor = UIColor.redColor()
        } else {
            cell.pheValue.textColor = UIColor.greenColor()
        }
        
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
    
    func calculateProtocolPheValue(someProtocols: [Protocol]) -> Double {
        var pheValue = 0.0
        for aProtocol in someProtocols{
            let base = Double((aProtocol.product?.pheValue)!) / Double((aProtocol.product?.basicAmount)!)
            pheValue += Double(aProtocol.amount!) * base
        }
      return pheValue
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        let viewController: ProtocolDetailViewController = segue.destinationViewController as! ProtocolDetailViewController
        
        // Pass the selected object to the new view controller.
        let key = self.reverseSortedDayProtocolsKeys[self.protocolTableView.indexPathForSelectedRow!.row]
        viewController.passedProtocols = self.dayProtocols[key]
        viewController.passedProtocolDate = key
    }
    

}
