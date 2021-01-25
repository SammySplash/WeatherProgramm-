//
//  WeatherCollectionCell.swift
//  WeatherProgramm
//
//  Created by user on 4/10/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit
import Charts

class WeatherCollectionCell: UICollectionViewCell{
    @IBOutlet weak var effectiveTemperture: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionImageView: UIImageView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupCell(from object: City){
        addImages(from: object)
        addText(from: object)
        cellSettings(for: object)
    }
    
    private func cellSettings(for object: City){
        UIElementsSettings.addParallaxToView(vw: weatherImageView)
        ChartController.shared.createChart(city: object, chartView: chartView)
        collectionView.reloadData()
    }
    
    private func addImages(from object: City){
        weatherDescriptionImageView.image = UIImage(named:GuardData.shared.guardString(for: object.icon))
        weatherImageView.image = UIImage(named: GuardData.shared.guardString(for: object.sky))
    }
    
    private func addText(from object: City){
        cityLabel.text =  object.tittle
        directionLabel.text = "Wind Direction: " + Direction(Double(GuardData.shared.guardInt(for: object.windDirection))).rawValue
        speedLabel.text = "Wind Speed: " + String(GuardData.shared.guardInt(for:object.windSpeed)) + Constants.windSpeedValue
        effectiveTemperture.text = "Effective Temperture: " + String(GuardData.shared.guardInt(for:object.effectiveTemperature)) + Constants.degreeIcon
        tempertureLabel.text =  String(GuardData.shared.guardInt(for:object.temperature)) + Constants.degreeIcon
    }
}
