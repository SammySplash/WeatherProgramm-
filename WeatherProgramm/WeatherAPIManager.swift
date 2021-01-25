//
//  WeatherAPIManager.swift
//  WeatherProgramm
//
//  Created by user on 4/9/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit

class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    private var iconsTittlesArray = [String]()
    private var summaryTemperture = 0.0
    private var count = 0.1
    
    func getData(lat: String, lon: String, completion: @escaping (_ result: String, _ error: String?, _ json: [String: Any]?)->()) {
        guard let url = URL(string: APIConfigurations.baseWeatherURL + "lat=" + lat + "&lon=" + lon + APIConfigurations.weatherAPIKey) else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, responce, error) in
            if error?.localizedDescription != nil{
                completion("Error", error?.localizedDescription, nil)
            }
            if responce != nil,let jsonData = data {
                DispatchQueue.main.async {
                    WeatherInfo.shared.delegate?.startActivityIndicator()
                }
                    if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                        let status = json?["cod"] as? String{
                        if Int(status)! > 200{
                            completion("Error", json?["message"] as? String, nil)
                        } else if Int(status)! == 200{
                            completion("Success", nil, json)
                        }  else  {
                            completion("Error", "Unidentified error. Try again later or contact the developer.", nil)
                        }
                    } else {
                        completion("Error", "Data from session incorrect.", nil)
                    }
            } else {
                completion("Error", "Check your internet connaction. App cannot work correctly.", nil)
            }
        }.resume()
    }
    
    func parseJson(json: [String:Any]?, lan: String, lon: String, with index: String, cityTittle: String){
        let city = City(longtitude: lon, lantitude: lan, tittle: cityTittle)
        dictionariesFromJson(city: city, json: json, index: index)
        DispatchQueue.main.async {
           WeatherInfo.shared.delegate?.stopActivityIndicator()
            WeatherInfo.shared.delegate?.updateData()
        }
    }
    
    private func infoDictionaries(city: City, cityDictionary: [String:Any], weatherArray: [Any], index: String){
         if let currentWeatherDictionary = weatherArray[Constants.count] as? [String:Any]{
            if let weatherMain = currentWeatherDictionary["main"] as? [String: Any],
                let weatherDescriptionArray = currentWeatherDictionary["weather"] as? [Any],
                let weatherWind = currentWeatherDictionary["wind"] as? [String: Any],
                let dayTimeDictionary = currentWeatherDictionary["sys"] as? [String: Any]{
                if let weatherDescriptionDictionary = weatherDescriptionArray[Constants.count] as? [String: Any]{
                    getValuesFromDay(city: city, weatherArray: weatherArray)
                    updateValues(city: city, weatherMain: weatherMain, weatherWind: weatherWind, weatherDescriptionDictionary: weatherDescriptionDictionary, cityDictionary: cityDictionary, index: index, dayTimeDictionary: dayTimeDictionary)
                }
            }
        }
    }
    
    private func dictionariesFromJson(city: City, json: [String:Any]?, index: String){
        if let cityDictionary = json?["city"] as? [String:Any],
            let weatherArray = json?["list"] as? [Any]{
            infoDictionaries(city: city, cityDictionary: cityDictionary, weatherArray: weatherArray, index: index)
        }
    }
    
    private func getValuesFromDay(city: City, weatherArray: [Any]){
        var startOfNextDay = (Calendar.current.startOfDay(for: Date()).timeIntervalSince1970) + Constants.nextDayIncrement
        for _ in Constants.fiveDayForecast {
            city.forecastDays.append(getWeatherDays(from: weatherArray, nextDayStart: startOfNextDay))
            startOfNextDay += Constants.nextDayIncrement
        }
    }
    
    private func updateValues(city:City,weatherMain:[String:Any],weatherWind:[String:Any],weatherDescriptionDictionary:[String:Any],cityDictionary: [String:Any], index: String, dayTimeDictionary: [String:Any]){
        dictionariesParseDoubles(city: city, weatherMain: weatherMain, weatherWind: weatherWind)
        dictionariesParseStrings(city: city, weatherDescriptionDictionary: weatherDescriptionDictionary, cityDictionary: cityDictionary, dayTimeDictionary: dayTimeDictionary)
        WeatherInfo.shared.updateArray(for: GuardData.shared.guardString(for: city.tittle), with: city, index: index)
    }
    
    private func dictionariesParseDoubles(city: City, weatherMain: [String:Any], weatherWind: [String:Any]){
        let temperature = weatherMain["temp"] as? Double
        let humidity = weatherMain["humidity"] as? Double
        let windSpeed = weatherWind["speed"] as? Double
        let windDirection = weatherWind["deg"] as? Double
        addDoubleValues(city: city, temperature: temperature, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection)
    }
    
    private func dictionariesParseStrings(city: City, weatherDescriptionDictionary: [String:Any], cityDictionary: [String:Any], dayTimeDictionary: [String: Any]){
        let description = weatherDescriptionDictionary["main"] as? String
        let icon = weatherDescriptionDictionary["icon"] as? String
        let dayTime = dayTimeDictionary["pod"] as? String
        addStringValues(city: city, description: description, icon: icon, dayTime: dayTime)
    }
    
    private func addDoubleValues(city: City, temperature: Double?, humidity: Double?, windSpeed:Double?, windDirection:Double?){
        city.setDoubles(temperature: temperature, windSpeed: windSpeed, windDirection: windDirection, effectiveTemperature: WeatherInfo.shared.effectiveTemperature(for: temperature, humidity: humidity, windSpeed: windSpeed))
    }
    
    private func addStringValues(city: City, description: String?, icon: String?, dayTime: String?){
        city.setStrings(sky: description, icon: icon, dayTime: dayTime)
    }
    
    private func setForecastValues(){
        iconsTittlesArray.removeAll()
        summaryTemperture = 0.0
        count = 0.1
    }
    
    private func initializedForecastValues(dictionary: [String:Any], nextDayStart: Double){
        let timeStamp = dictionary["dt"] as? Double
        let weatherArray = dictionary["weather"] as? [Any]
        let weatherDictionary = weatherArray?[0] as? [String:Any]
        let sys = dictionary["sys"] as? [String:Any]
        let dayStamp = sys?["pod"] as? String
        checkForecastMatches(timeStamp: timeStamp, nextDayStart: nextDayStart, dayStamp: dayStamp, dictionary: dictionary, weatherDictionary: weatherDictionary)
    }
    
    private func checkForecastMatches(timeStamp: Double?, nextDayStart: Double, dayStamp: String?, dictionary: [String:Any]?, weatherDictionary: [String: Any]?){
        if GuardData.shared.guardDouble(for: timeStamp) > nextDayStart && GuardData.shared.guardDouble(for: timeStamp) < nextDayStart + Constants.nextDayIncrement && dayStamp == "d"{
            if let tempertureDictionary = dictionary?["main"] as? [String: Any]{
                let iconTittle = weatherDictionary?["icon"] as? String
                let temperture = tempertureDictionary["temp"] as? Double
                iconsTittlesArray.append(GuardData.shared.guardString(for: iconTittle))
                summaryTemperture += GuardData.shared.guardDouble(for:temperture)
                count += 1
            }
        }
    }
    private func arrayForecastIterator(from array: [Any], nextDayStart: Double){
        for element in array{
            if let dictionary = element as? [String: Any]{
                initializedForecastValues(dictionary: dictionary, nextDayStart: nextDayStart)
            }
        }
    }
    
    private func getWeatherDays(from array: [Any], nextDayStart: Double)->Forecast{
        setForecastValues()
        arrayForecastIterator(from: array, nextDayStart: nextDayStart)
        return Forecast(dayIconTittle: GuardData.shared.guardString(for: iconsTittlesArray.first), dayTemperture: Int(summaryTemperture/count))
    }
}


