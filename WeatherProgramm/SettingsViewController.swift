//
//  SettingsViewController.swift
//  WeatherProgramm
//
//  Created by user on 4/5/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SettingsViewControllerProtocol?
    
    override func viewDidLoad(){
        WeatherInfo.shared.delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        weatherImageView.image = UIImage(named: GuardData.shared.guardString(for: WeatherInfo.shared.cityList.first?.sky)) 
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.delegate?.sendCurrentCity()
        backToMainView()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton){
        openSearchView()
    }
    
    private func openSearchView(){
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else  {
            return
        }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func backToMainView(){
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, SearchViewControllerProtocol, WeatherInfoProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return WeatherInfo.shared.cityListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.setupCell(from: WeatherInfo.shared.cityList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.delegate?.sendSelectCity(for: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if indexPath.row > 0  {
            guard editingStyle == .delete else { return }
            WeatherInfo.shared.removeCity(from: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func sendData(from coordinates: String, cityTittle: String){
        let LongLat: [Substring] = coordinates.split(separator: " ")
        WeatherInfo.shared.getWeather(lat: String(LongLat[1]), lon: String(LongLat[0]), with: "Last", cityTittle: cityTittle)
    }
   
    func updateData(){
        tableView.reloadData()
    }
    
    func startActivityIndicator(){}
    
    func stopActivityIndicator(){}
    
    func errorSender(with text: String){}
}

