//
//  ChartController.swift
//  WeatherProgramm
//
//  Created by user on 4/16/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import Charts

class ChartController: LineChartView{
    static let shared = ChartController()
    private var days: [String]! = []
    private var linechartEntries = [ChartDataEntry]()
    
    func createChart(city: City, chartView: LineChartView){
        linechartEntries.removeAll()
        entriesToArray(from: city)
        entriesFormatter(for: chartView)
        entriesToChart(for: chartView)
    }
    
    private func entriesToArray(from object: City){
        for index in 0..<object.forecastDays.count{
            let entry = ChartDataEntry(x: Double(index), y: Double(GuardData.shared.guardInt(for: object.forecastDays[index].dayTemperture)))
            days.append(WeatherInfo.shared.dayTittle(index))
            linechartEntries.append(entry)
        }
    }
    
    private func entriesToChart(for chartView: LineChartView){
        let dataSet = LineChartDataSet(entries: linechartEntries, label: "temperature")
        let data = LineChartData(dataSet: dataSet)
        chartSettings(dataSet: dataSet, chartView: chartView)
        chartView.data = data
    }
    
    private func entriesFormatter(for chartView: LineChartView){
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.granularity = 1
    }
    
    private func chartSettings(dataSet: LineChartDataSet, chartView: LineChartView){
        dataSetSettings(dataSet: dataSet)
        chartColors(dataSet: dataSet, chartView: chartView)
        axisSettings(chartView: chartView)
        addGradient(dataSet: dataSet)
    }
    
    private func axisSettings(chartView: LineChartView){
        yAxisLeftSettings(chartView: chartView)
        yAxisRightSettings(chartView: chartView)
        xAxisSettings(chartView: chartView)
    }
    
    private func yAxisLeftSettings(chartView: LineChartView){
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.labelFont = UIFont(name: "Futura", size: 10)!
        chartView.leftAxis.labelTextColor = UIColor.white
    }
    
    private func yAxisRightSettings(chartView: LineChartView){
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.labelFont = UIFont(name: "Futura", size: 10)!
        chartView.rightAxis.labelTextColor = UIColor.white
    }
    
    private func xAxisSettings(chartView: LineChartView){
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelFont = UIFont(name: "Futura", size: 15)!
        chartView.xAxis.labelTextColor = UIColor.white
    }
    
    private func dataSetSettings(dataSet: LineChartDataSet){
        dataSet.mode = .cubicBezier
        dataSet.circleRadius = 0
        dataSet.valueTextColor = UIColor.clear
    }
    
    private func addGradient(dataSet: LineChartDataSet){
        let gradientColors = [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        dataSet.drawFilledEnabled = true
    }
    
    private func chartColors(dataSet: LineChartDataSet, chartView: LineChartView){
        chartView.chartDescription?.textColor = UIColor.white
        chartView.legend.enabled = false
        chartView.backgroundColor = UIColor.clear
    }
}

