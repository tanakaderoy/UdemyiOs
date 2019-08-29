//
//  Question.swift
//  Quizzler
//
//  Created by Tanaka Mazivanhanga on 7/15/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class Question {
    let question: String
    let answer : Bool
    init(question: String, answer: Bool) {
        self.question = question
        self.answer = answer
    }
}
