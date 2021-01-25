//
//  CityInfo.swift
//  WeatherProgramm
//
//  Created by user on 4/11/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

class CityInfo{
    static let shared = CityInfo()
    var cityList = [String: String]()
    weak var delegate: CityInfoProtocol?
    
    func getCity(cityName: String){
        clearSearchCitiesDictionary()
        CityAPIManager.shared.searchCity(cityName: cityName) { (result, error, json) in
            if result == "Success"{
                CityAPIManager.shared.parseJson(json: json)
            } else if result == "Error" {
                self.callProtocolFunctions(error: error)
            }
        }
    }
    
    func clearSearchCitiesDictionary(){
        cityList.removeAll()
    }
    
    private func callProtocolFunctions(error: String?){
        DispatchQueue.main.async {
            self.delegate?.stopActivityIndicator()
            self.delegate?.errorSender(with: GuardData.shared.guardString(for: error))
        }
    }
}

