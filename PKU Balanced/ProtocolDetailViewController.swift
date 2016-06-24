//
//  ProtocolDetailViewController.swift
//  PKU Balanced
//
//  Created by Raphael Huber on 23.06.16.
//  Copyright © 2016 Raphael Huber. All rights reserved.
//

import UIKit

class ProtocolDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pheLabel: UILabel!
    @IBOutlet weak var protocolTableView: UITableView!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let numberFormatter = (UIApplication.sharedApplication().delegate as! AppDelegate).numberFormatter
    
    var passedProtocols: [Protocol]!
    var passedProtocolDate: String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        protocolTableView.dataSource = self
        protocolTableView.delegate = self
        
        self.dateLabel.text = self.passedProtocolDate
        
        var calc = 0.0
        for aProtocol in passedProtocols {
            calc += self.calculatePheValue(aProtocol)
        }
        self.pheLabel.text = "Total: " + self.numberFormatter.stringFromNumber(calc)!
        
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
        return self.passedProtocols.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protocolCell", forIndexPath: indexPath) as! DetailProtocolTableViewCell
        
        // Configure the cell...
        let aProtocol = passedProtocols[indexPath.row]
        cell.productName.text = aProtocol.product?.name
        cell.amount.text = "\(aProtocol.amount!) \(aProtocol.product!.baseUnit!)"
        cell.pheValue.text = self.numberFormatter.stringFromNumber(calculatePheValue(aProtocol))
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func calculatePheValue(aProtocol: Protocol) -> Double {
        return Double(aProtocol.amount!) * (Double((aProtocol.product?.pheValue)!) / Double((aProtocol.product?.basicAmount)!))
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
