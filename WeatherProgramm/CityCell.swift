//
//  CityCell.swift
//  WeatherProgramm
//
//  Created by user on 4/7/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell{
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempertureLabel: UILabel!
    
    func setupCell(from object: City){
        cityNameLabel.text =  object.tittle
        weatherImageView.image = UIImage(named: GuardData.shared.guardString(for:  object.sky))
        tempertureLabel.text = String(GuardData.shared.guardInt(for: object.temperature)) + Constants.degreeIcon
    }
}
