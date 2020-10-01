//
//  RequestTokenResponse.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 22/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation


class RequestTokenResponse:Codable{
    let response_code:Int
    let response_message:String
    let token:String
}

