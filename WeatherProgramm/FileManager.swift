//
//  FileManager.swift
//  WeatherProgramm
//
//  Created by user on 4/13/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

class FileManager{
    static let shared = FileManager()
    private let defaults = UserDefaults.standard
    
    func saveCities(){
        defaults.set(WeatherInfo.shared.cityListCount(), forKey: "Count")
        for index in 0..<WeatherInfo.shared.cityListCount(){
            defaults.set(stringConcatenation(index: index), forKey: "City" + String(index))
        }
    }
    
    func loadCity(){
        let count = defaults.integer(forKey: "Count")
        for index in 0..<count{
            let LongLat: [Substring] = defaults.string(forKey: "City" + String(index))!.split(separator: "_")
            WeatherInfo.shared.getWeather(lat: String(LongLat[0]), lon: String(LongLat[1]), with: "Last", cityTittle: String(LongLat[2]))
        }
    }
    
    private func stringConcatenation(index: Int)->String{
        return String(GuardData.shared.guardString(for: WeatherInfo.shared.cityList[index].lantitude) + "_"
            + GuardData.shared.guardString(for:WeatherInfo.shared.cityList[index].longtitude) + "_"
            + GuardData.shared.guardString(for:WeatherInfo.shared.cityList[index].tittle))
    }
}
