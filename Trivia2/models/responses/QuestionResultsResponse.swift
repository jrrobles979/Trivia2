//
//  QuestionResultsResponse.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

class QuestionResultsResponse:Codable {
    let response_code:Int
    let results: [QuestionsResponse]
}
