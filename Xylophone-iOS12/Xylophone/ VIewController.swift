//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    var audioPlayer = AVAudioPlayer()
    var soundFileName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func playSound(_ note: Int) {
        print(note)
        soundFileName = "note\(note)"
        let url = Bundle.main.url(forResource: soundFileName, withExtension: "wav")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as Error {
            print(error.localizedDescription)
        }
        
        
    }



    @IBAction func notePressed(_ sender: UIButton) {
        let tag = sender.tag
        playSound(tag)
//        switch tag {
//        case 1:
//            print(1)
//        case 2:
//            print(2)
//        case 3:
//            print(3)
//        case 4:
//            print(4)
//        case 5:
//            print(5)
//        case 6:
//            print(6)
//        case 7:
//            print(7)
//        default:
//            print("")
//        }
        
        
    }
    
  

}

