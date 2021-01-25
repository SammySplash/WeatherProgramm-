//
//  MainViewController.swift
//  WeatherProgramm
//
//  Created by user on 4/9/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController{
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var currentPage: Int?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        WeatherInfo.shared.delegate = self
        LocationManager.shared.settings(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        pageControl.numberOfPages = WeatherInfo.shared.cityListCount()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton){
        openSettingsView()
    }
    
    private func openSettingsView(){
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WeatherInfoProtocol, SettingsViewControllerProtocol{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == citiesCollectionView{ return WeatherInfo.shared.cityListCount()}
        else {return WeatherInfo.shared.cityList[section].forecastDays.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == citiesCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionCell", for: indexPath) as? WeatherCollectionCell else {
                return UICollectionViewCell()
            }
            currentPage = indexPath.row
            cell.setupCell(from: WeatherInfo.shared.cityList[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setupCell(for: WeatherInfo.shared.cityList[GuardData.shared.guardInt(for: currentPage)], index: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == citiesCollectionView{return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)}
        else {return CGSize(width: 100, height: collectionView.frame.height)}
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if collectionView == citiesCollectionView{
            self.pageControl.currentPage = indexPath.row
        }
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        indicatorView.isHidden = true
    }
    
    func startActivityIndicator(){
        indicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func sendCurrentCity(){
        citiesCollectionView.reloadData()
    }
    
    func sendSelectCity(for indexPath: IndexPath){
        citiesCollectionView.reloadData()
        citiesCollectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        self.pageControl.currentPage = indexPath.row
        citiesCollectionView.reloadData()
    }
    
    func updateData(){
        pageControl.numberOfPages = WeatherInfo.shared.cityListCount()
        pageControl.updateCurrentPageDisplay()
        citiesCollectionView.reloadData()
    }
    
    func errorSender(with text: String){
        present(Alerts.alert(text: text), animated: true)
    }
}

