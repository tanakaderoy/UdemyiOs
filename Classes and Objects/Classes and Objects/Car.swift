//
//  Car.swift
//  Classes and Objects
//
//  Created by Tanaka Mazivanhanga on 7/16/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation


enum CarType {
    case Sedan
    case Coupe
    case Hatchback
}
enum CarColor: String {
    case blue = "blue"
    case red = "red"
    case black = "black"
}

class Car {
    var color = "Black"
    var numberOfSeats = 5
    var typeOfCar: CarType = .Coupe
    init() {
        
    }
    convenience init(color: CarColor) {
        self.init()
        self.color = color.rawValue
    }
    func drive() {
        print("car is moving")
    }
    
}
class SelfDrivingCar: Car {
    var destination : String?
    
    override func drive() {
        super.drive()
        if let destination = destination{
             print("driving to \(destination)")
        }else{
            print("no destination")
        }
       
    }
}
