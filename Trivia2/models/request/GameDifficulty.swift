//
//  GameDifficulty.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
public enum GameDifficulty:Int, CaseIterable{
    case all,easy,medium, hard, unknown = 100
    
    var stringValue: String {
        switch self {
        case .all: return "all"
        case .easy: return "easy"
        case .medium: return "medium"
        case .hard: return "hard"
        case .unknown: return "unknown"
        }}
    
    var labelValue: String {
        switch self {
        case .all: return "All"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .unknown: return "Unknown"
        }}
    
    var gamePointValue: Int {
        switch self {
        case .all: return 0
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        case .unknown: return 0
        }}
    
    
    static func byStringValue(name: String) -> GameDifficulty {
        return GameDifficulty.allCases.first(where: {$0.stringValue.elementsEqual(name)}) ?? .unknown
    }
    
}
