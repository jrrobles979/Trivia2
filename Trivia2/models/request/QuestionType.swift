//
//  QuestionType.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

enum QuestionType:Int,CaseIterable{
    case multiple, truefalse , unknown = 100
    var stringValue: String {
        switch self {
        case .multiple: return "multiple"
        case .truefalse: return "boolean"
        case .unknown: return "unknown"
        }}
    var labelValue: String {
        switch self {
        case .multiple: return "Multiple Choice"
        case .truefalse: return "True/False"
        case .unknown: return "Unknown"
        }}
    
    static func byStringValue(name: String) -> QuestionType {
           return QuestionType.allCases.first(where: {$0.stringValue.elementsEqual(name)}) ?? .unknown
       }
}
