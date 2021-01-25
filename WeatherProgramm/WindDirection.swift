//
//  WindDirection.swift
//  WeatherProgramm
//
//  Created by user on 4/13/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation

enum Direction: String {
    case North, NorthEast, East, SouthEast, South, SouthWeast, West, NorthWest
}

extension Direction: CustomStringConvertible  {
    static let all: [Direction] = [.North, .NorthEast, .East, .SouthEast, .South, .SouthWeast, .West, .NorthWest]
    
    init(_ direction: Double) {
        let index = Int((direction + 22.25).truncatingRemainder(dividingBy: 360) / 45)
        self = Direction.all[index]
    }
    
    var description: String {
        return rawValue.uppercased()
    }
}

extension Double {
    var direction: Direction {
        return Direction(self)
    }
}
