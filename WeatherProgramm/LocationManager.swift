//
//  LocationManager.swift
//  WeatherProgramm
//
//  Created by user on 4/19/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager:NSObject, CLLocationManagerDelegate{
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    func settings(delegate selfController: CLLocationManagerDelegate){
        LocationManager.shared.locationManager.delegate = selfController
        LocationManager.shared.locationManager.requestAlwaysAuthorization()
        LocationManager.shared.locationManager.startUpdatingLocation()
    }
}

extension MainViewController: CLLocationManagerDelegate{
    func callWeatherAPI(location: CLLocation){
        location.geocode { (placemark, error) in
            if let placemark = placemark?.first {
                WeatherInfo.shared.getCurrentWeather(lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude), cityTittle: placemark.locality!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if WeatherInfo.shared.cityListCount() == 0 {
            FileManager.shared.loadCity()
        }
        if let location = locations.last {
            callWeatherAPI(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined: present(Alerts.alert(text:  Alerts.locationAlertText), animated: true)
            case .authorizedWhenInUse: print("authorizedWhenInUse")
            case .authorizedAlways: print("authorizedAlways")
            case .restricted: present(Alerts.alert(text:  Alerts.locationAlertText), animated: true)
            case .denied: present(Alerts.alert(text:  Alerts.locationAlertText), animated: true)
        }
    }
}

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
