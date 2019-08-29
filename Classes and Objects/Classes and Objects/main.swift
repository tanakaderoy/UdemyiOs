//
//  main.swift
//  Classes and Objects
//
//  Created by Tanaka Mazivanhanga on 7/16/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
let otherCar = Car()
let myCar = Car(color: .blue)
myCar.color = "Blue"
myCar.numberOfSeats = 4
myCar.typeOfCar = .Sedan
print(otherCar.color)
myCar.drive()
var tesla = SelfDrivingCar()
tesla.drive()

