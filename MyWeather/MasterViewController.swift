//
//  MasterViewController.swift
//  MyWeather
//
//  Created by Clayton Harper on 2/25/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MasterViewController: UITableViewController {
	
	let apiKey: String = "523088988686ed552a8beddd5fa7686b"
	
	var detailViewController: DetailViewController? = nil
	var weather	= [Weather]()


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()

		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		self.navigationItem.rightBarButtonItem = addButton
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=39.8361&lon=-105.0372&unit=imperial&appid=\(apiKey)")
		Alamofire.request(.GET, url!).validate().responseJSON { response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					print("JSON: \(json["list"])")
					// Parse
					for obj in json["list"].arrayValue {
						self.weather.append(Weather(dateAndTime: obj["dt_txt"].stringValue, temperature: obj["temp"].floatValue, main: obj["weather"][0]["main"].stringValue))
					}
					self.tableView.reloadData()
					print(self.weather)
				}
			case .Failure(let error):
				print(error)
			}
		}

	}

	override func viewWillAppear(animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

//	func insertNewObject(sender: AnyObject) {
//		objects.insert(NSDate(), atIndex: 0)
//		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let object = weather[indexPath.row]
		        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weather.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let object = weather[indexPath.row]
		cell.textLabel!.text = object.shortDescription()
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		    weather.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}


}

