//
//  QuestionGlobalCount.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 25/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

class QuestionGlobalCount:Codable{
    let total_num_of_questions:Int
    let total_num_of_pending_questions:Int
    let total_num_of_verified_questions:Int
    let total_num_of_rejected_questions:Int
}
