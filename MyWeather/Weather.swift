//
//  Weather.swift
//  MyWeather
//
//  Created by Clayton Harper on 2/25/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import Foundation

public class Weather {
	
	public var dateAndTime: String
	public var temperature: Float
	public var main: String
	
	init (dateAndTime: String, temperature: Float, main: String) {
		self.dateAndTime = dateAndTime
		self.temperature = temperature
		self.main = main
	}
	
	func shortDescription () -> String {
		var fancyString: String = ""
		fancyString += "\(dateAndTime), "
		fancyString += "\(temperature), "
		fancyString += "\(main)"
		return fancyString
	}
}