//
//  ViewController.swift
//  Dicee
//
//  Created by Tanaka Mazivanhanga on 7/15/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var diceView1: UIImageView!
    @IBOutlet weak var diceView2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeDiceImages()
        // Do any additional setup after loading the view.
    }
    let diceImageNames = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    var dice1Index = 0, dice2Index = 0

    
    func randomizeDiceImages() {
        dice1Index = Int.random(in: 0 ... 5)
        dice2Index = Int.random(in: 0 ... 5)
        diceView1.image = UIImage(named: diceImageNames[dice1Index])
        diceView2.image = UIImage(named: diceImageNames[dice2Index])
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        randomizeDiceImages()
    }

    @IBAction func rollButtonTouched(_ sender: UIButton) {
        randomizeDiceImages()


    }
    
}

