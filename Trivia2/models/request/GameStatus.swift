//
//  GameStatus.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 27/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

enum GameStatus:Int,CaseIterable{
    
    case none, created, starting, playing, completed, unknown = 100
    
    var nameEnum: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }

    func byName(name: String) -> GameStatus {
        return GameStatus.allCases.first(where: {$0.nameEnum.elementsEqual(name)}) ?? .unknown
    }
    
    
}
