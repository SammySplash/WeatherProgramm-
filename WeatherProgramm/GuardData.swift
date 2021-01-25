//
//  GuardData.swift
//  WeatherProgramm
//
//  Created by user on 4/10/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit

class GuardData {
    static let shared = GuardData()
    
    func guardString(for text: String?)->String{
        guard let string = text  else  {
            return "City"
        }
        return string
    }
    
    func guardInt(for text: Int?)->Int{
        guard let int = text  else  {
            return 0
        }
        return int
    }
    
    func guardDouble(for text: Double?)->Double{
        guard let int = text  else  {
            return 0.0
        }
        return int
    }
}
