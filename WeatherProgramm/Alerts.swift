//
//  Alerts.swift
//  WeatherProgramm
//
//  Created by user on 4/13/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit

struct Alerts{
    static let locationAlertText = "Check that your location is available, because app cannot load your current location and we use your previous coordanates."
    
    static func alert(text: String)->UIAlertController{
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_)->Void in
            openSettings()
        }))
        return alert
    }
    
    static private func openSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (_)-> Void in})
        }
    }
}
