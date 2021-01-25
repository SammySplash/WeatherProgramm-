//
//  Constanst.swift
//  WeatherProgramm
//
//  Created by user on 4/13/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

struct Constants {
    static var count = 0
    static var nextDayIncrement:Double = (24*60*60)
    static var fiveDayForecast = [1,2,3,4,5]
    static var degreeIcon = "°"
    static var windSpeedValue = "m/s"
    
    static func removeCount(){
        count = 0
    }
    static func incrementCount(){
        count += 1
    }
}

