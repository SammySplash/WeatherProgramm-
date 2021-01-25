//
//  APIConfigurations.swift
//  WeatherProgramm
//
//  Created by user on 4/9/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

struct APIConfigurations {
    static let baseWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?"
    static let weatherAPIKey = "&APPID=c1730ba19316b966e1c2369773febc41&units=metric"
    static let baseCitySearchURL = "https://geocode-maps.yandex.ru/1.x/?lang=en_us"
    static let citySearchAPIKey = "&apikey=88e3e791-95c9-4c0c-9918-f931e669bff5&geocode="
}
