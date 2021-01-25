//
//  City.swift
//  WeatherProgramm
//
//  Created by user on 4/7/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit

class City {
    var tittle: String?
    var longtitude: String?
    var lantitude: String?
    var temperature: Int?
    var sky: String?
    var windSpeed: Int?
    var windDirection: Int?
    var effectiveTemperature: Int?
    var forecastDays = [Forecast]()
    var icon: String?
    var dayTime: String?
    
    init(longtitude: String,lantitude: String, tittle: String) {
        self.tittle = tittle
        self.longtitude = longtitude
        self.lantitude = lantitude
    }
    
    func setDoubles(temperature:Double?, windSpeed: Double?, windDirection: Double?, effectiveTemperature: Int?){
        self.temperature = Int(GuardData.shared.guardDouble(for: temperature))
        self.windSpeed = Int(GuardData.shared.guardDouble(for: windSpeed))
        self.windDirection = Int(GuardData.shared.guardDouble(for: windDirection))
        self.effectiveTemperature = effectiveTemperature
    }
    
    func setStrings(sky: String?, icon: String?, dayTime: String?){
        if dayTime == "n" {self.sky = "Night"}
        else {self.sky = sky}
        self.icon = icon
    }
}
