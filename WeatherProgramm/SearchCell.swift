//
//  SearchCell.swift
//  WeatherProgramm
//
//  Created by user on 4/7/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell{
    @IBOutlet weak var cityNameLabel: UILabel!
    
    func setupCell(_ sender: String){
        cityNameLabel.text = sender
    }
}
