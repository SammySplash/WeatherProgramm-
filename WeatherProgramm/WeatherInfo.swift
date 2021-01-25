//
//  WeatherInfo.swift
//  WeatherProgramm
//
//  Created by user on 4/7/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit



class WeatherInfo {
    static let shared = WeatherInfo()
    var cityList = [City]()
    weak var delegate: WeatherInfoProtocol?
    
    func getWeather(lat: String, lon: String, with index: String, cityTittle: String){
        WeatherAPIManager.shared.getData(lat: lat, lon: lon) { (result, error, json) in
            if result == "Success"{
                WeatherAPIManager.shared.parseJson(json: json, lan: lat, lon: lon, with: index, cityTittle: cityTittle)
            } else if result == "Error"{
                self.callProtocolFunctions(error: error)
            } 
        }
    }
    
    func getCurrentWeather(lat: String, lon: String, cityTittle: String){
        if cityList.isEmpty{
            getWeather(lat: lat, lon: lon, with: "Last", cityTittle: cityTittle)
        } else if cityList[0].longtitude != lon && cityList[0].lantitude != lat{
            getWeather(lat: lat, lon: lon, with: "First", cityTittle: cityTittle)
        }
    }
    
    func dayTittle(_ sender: Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: sender+1, to: Date()) ?? Date())
    }
    
    func updateArray(for cityName: String, with object: City, index: String){
        if index == "Last" {
            if let row = self.cityList.index  (where: {$0.tittle == cityName}) {
                cityList[row] = object
            } else {
                cityList.append(object)
            }
        } else if index == "First" {
            cityList[0] = object
        }
    }
    
    func reloadWeatherData(){
        WeatherInfo.shared.cityList.forEach { (city) in
            WeatherInfo.shared.getWeather(lat: GuardData.shared.guardString(for: city.lantitude), lon: GuardData.shared.guardString(for: city.longtitude), with: "Last", cityTittle: GuardData.shared.guardString(for: city.tittle))
        }
    }
    
    func effectiveTemperature(for temperature: Double?, humidity: Double?, windSpeed: Double?) -> Int{
        let currentT2 = pow(GuardData.shared.guardDouble(for: temperature), 2.0)
        let currentHumidity2 = pow(GuardData.shared.guardDouble(for: humidity), 2.0)
        let currectWindSpeed016 = pow(GuardData.shared.guardDouble(for: windSpeed), 0.16)
        switch GuardData.shared.guardDouble(for: temperature){
        case ...27.0:
            return Int(13.12 + 0.6215 * GuardData.shared.guardDouble(for: temperature) - 11.37 * currectWindSpeed016 + 0.3965 * GuardData.shared.guardDouble(for: temperature) * currectWindSpeed016)
        case 27.0...:
            return effectiveTemperatureFormula(temperature: GuardData.shared.guardDouble(for: temperature), humidity: GuardData.shared.guardDouble(for: humidity), currentT2: currentT2, currentHumidity2: currentHumidity2)
        default:
            return Int(GuardData.shared.guardDouble(for: temperature))
        }
    }
    
    func removeCity(from index: Int){
        cityList.remove(at: index)
    }
    
    func cityListCount()->Int{
        return cityList.count
    }
    
    private func callProtocolFunctions(error: String?){
        DispatchQueue.main.async {
            self.delegate?.stopActivityIndicator()
            self.delegate?.errorSender(with: GuardData.shared.guardString(for: error))
        }
    }
    
    private func effectiveTemperatureFormula(temperature: Double, humidity: Double, currentT2: Double, currentHumidity2: Double)->Int{
        return Int((-8.78469475556) + (1.61139411 * temperature) + (2.33854883889 * humidity) + (-0.14611605 * temperature * humidity) + (-0.012308094 * currentT2) + (-0.0164248277778 * currentHumidity2) + (0.002211732 * currentT2 * humidity) + (0.00072546 * temperature * currentHumidity2) + (-0.000003582 * currentT2) * currentHumidity2)
    }
}
