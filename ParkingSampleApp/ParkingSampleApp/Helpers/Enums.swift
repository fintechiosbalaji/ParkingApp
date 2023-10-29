//
//  Enums.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//


import CoreData
import UIKit

enum VehicleType: String {
    case motorcycle = "Motorcycle"
    case car = "Car"
    case bus = "Bus"
}

enum ParkingCategory: String {
    case theatre = "Theatre"
    case mall = "Mall"
}

enum ParkingSpots {
    static let predefinedSpots: [ParkingCategory: [VehicleType: Int]] = [
        .theatre: [
            .motorcycle: 5,
            .car: 5,
            .bus: 5
        ],
        .mall: [
            .motorcycle: 10,
            .car: 15,
            .bus: 5
        ]
    ]
}


