//
//  CategoryQuestionResponse.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 25/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
class CategoryQuestionResponse:Codable{
    let category_id:Int
    let category_question_count:[CategoryQuestionCount]
}
