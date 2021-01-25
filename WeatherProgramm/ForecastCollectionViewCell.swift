//
//  ForecastCollectionViewCell.swift
//  WeatherProgramm
//
//  Created by user on 4/16/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var dayTittleLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    func setupCell(for object: City, index: Int){
        tempertureLabel.text = String(GuardData.shared.guardInt(for: object.forecastDays[index].dayTemperture)) + Constants.degreeIcon
        weatherIconImageView.image = UIImage(named: GuardData.shared.guardString(for: object.forecastDays[index].dayIconTittle))
        dayTittleLabel.text = WeatherInfo.shared.dayTittle(index)
    }
}
