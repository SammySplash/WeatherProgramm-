//
//  Forecast.swift
//  WeatherProgramm
//
//  Created by user on 4/15/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
class Forecast {
    var dayIconTittle: String?
    var dayTemperture: Int?
    
    init(dayIconTittle: String, dayTemperture: Int ){
        self.dayTemperture = dayTemperture
        self.dayIconTittle = dayIconTittle
    }
}
