//
//  CategoryResponse.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation


class CategoryResponse:Codable{
    let id:Int
    let name:String
    
    init(id:Int, name:String){
        self.id=id
        self.name=name        
    }
}
