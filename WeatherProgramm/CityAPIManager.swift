//
//  CityAPIManager.swift
//  WeatherProgramm
//
//  Created by user on 4/11/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

class CityAPIManager {
    static let shared = CityAPIManager()
    
    func searchCity(cityName: String, completion: @escaping (_ result: String, _ error: String?, _ json: [String: Any]?)->()){
        guard let url = URL(string: APIConfigurations.baseCitySearchURL + APIConfigurations.citySearchAPIKey + cityName + "&format=json") else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) {(data, responce, error) in
            if error?.localizedDescription != nil{
                completion("Error", error?.localizedDescription, nil)
            }
            if responce != nil,let jsonData = data {
                DispatchQueue.main.async {
                    CityInfo.shared.delegate?.startActivityIndicator()
                }
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                    if let status = json?["error"] as? [String: Any]{
                        completion("Error", status["message"] as? String, nil)
                    } else if let response = json?["response"] as? [String: Any]{
                        if !response.isEmpty{
                            completion("Success", nil, json)
                        } else  {
                            completion("Error", "Unidentified error. Try again later or contact the developer.", nil)
                        }
                    } else {
                        completion("Error", "Unidentified error. Try again later or contact the developer.", nil)
                    }
                } else {
                    completion("Error", "Unidentified error. Try again later or contact the developer.", nil)
                }
            }
        }.resume()
    }
    
    func parseJson(json: [String:Any]?){
        if let featureMember = parseFeatureMember(json: json) as? [Any]{
            featureMemberArrayIterator(featureMember: featureMember)
        }
        DispatchQueue.main.async {
            CityInfo.shared.delegate?.stopActivityIndicator()
            CityInfo.shared.delegate?.updateData()
        }
    }
    
    private func featureMemberArrayIterator(featureMember: [Any]){
        for featureMemberDictionary in featureMember{
            parseCityInfo(featureMemberDictionary: featureMemberDictionary)
        }
    }
    
    private func parseCityInfo(featureMemberDictionary: Any){
        let dataDictionary = featureMemberDictionary as? [String: Any]
        if let geoObject = dataDictionary?["GeoObject"]as? [String: Any]{
            if let cityName = geoObject["name"] as? String,
                let cityPointDictionary = geoObject["Point"] as? [String: Any]{
                if let cityPoint = cityPointDictionary["pos"] as? String{
                    CityInfo.shared.cityList.updateValue(cityPoint, forKey: cityName)
                }
            }
        }
    }
    
   private func parseFeatureMember(json: [String:Any]?)->Any?{
        if let responce = json?["response"] as? [String: Any]{
            if let geoObjectCollection = responce["GeoObjectCollection"] as? [String: Any]{
                return geoObjectCollection["featureMember"]
            }
        }
        return nil
    }
}
