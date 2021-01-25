//
//  Protocols.swift
//  WeatherProgramm
//
//  Created by user on 4/16/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

protocol SettingsViewControllerProtocol: AnyObject {
    func sendSelectCity(for indexPath: IndexPath)
    func sendCurrentCity()
}

protocol SearchViewControllerProtocol: AnyObject {
    func sendData(from coordinates: String, cityTittle: String)
}

protocol CityInfoProtocol: AnyObject{
    func updateData()
    func startActivityIndicator()
    func stopActivityIndicator()
    func errorSender(with text: String)
}

protocol WeatherInfoProtocol: AnyObject {
    func updateData()
    func startActivityIndicator()
    func stopActivityIndicator()
    func errorSender(with text: String)
}
