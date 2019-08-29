//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var pickedAnswer = false
    var questionNumber = 0
    var score = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        print(allQuestions.list[allQuestions.list.count - 1].question)
          
        
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag == 1{
            pickedAnswer = true
            
        }else if sender.tag == 2{
            pickedAnswer = false
        }
        checkAnswer()
        nextQuestion()
    }
    
    
    func updateUI() {
      questionLabel.text = allQuestions.list[questionNumber].question
        progressLabel.text = "\(questionNumber + 1)/\(allQuestions.list.count)"
        scoreLabel.text = "\(score)"
        progressBar.frame.size.width = (view.frame.width / CGFloat(allQuestions.list.count)) * CGFloat(questionNumber)
    }
    

    func nextQuestion() {
       
        
        if questionNumber < allQuestions.list.count - 1 {
            questionNumber += 1
         updateUI()
            
        }else{
            let alert = UIAlertController(title: "Finished", message: "You Have Finished", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                
                self.startOver()
            }
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
            
        }
     
       
    }
    
    
    func checkAnswer() {

        if pickedAnswer == allQuestions.list[questionNumber].answer{
            score += 1
            ProgressHUD.showSuccess("Correct")
        }else{
            ProgressHUD.showError("Wrong!")
            //score -= 1
        }
    }
    
    
    func startOver() {
        
       questionNumber = 0
        score = 0
        updateUI()
    }
    

    
}
