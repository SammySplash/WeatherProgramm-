//
//  SearchViewController.swift
//  WeatherProgramm
//
//  Created by user on 4/7/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SearchViewControllerProtocol?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        CityInfo.shared.delegate = self
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        CityInfo.shared.clearSearchCitiesDictionary()   
    }
    
    private func backToPreviousView(){
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CityInfoProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityInfo.shared.cityList.count   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        cell.setupCell(Array(CityInfo.shared.cityList)[indexPath.row].key)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.delegate?.sendData(from: Array(CityInfo.shared.cityList)[indexPath.row].value, cityTittle: Array(CityInfo.shared.cityList)[indexPath.row].key)
        backToPreviousView()
    }
    
    func startActivityIndicator(){
        if !CityInfo.shared.cityList.isEmpty {
            indicatorView.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator(){
        indicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        backToPreviousView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard let searchBartext = searchBar.text?.replacingOccurrences(of: " ", with: "+") else {return}
        if !searchText.isEmpty{
            CityInfo.shared.getCity(cityName: GuardData.shared.guardString(for: searchBartext))
        }
    }
        
    func errorSender(with text: String){
        present(Alerts.alert(text: text), animated: true)
    }
    
    func updateData(){
        tableView.reloadData()
    }
}


