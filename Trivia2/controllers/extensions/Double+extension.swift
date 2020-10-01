//
//  Double+extension.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 03/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

extension Double {
    
    /// 1.00234 -> 1.0
    var integerPart: Double {
        return Double(Int(self))
    }
    
    /// 1.0012 --> 0.0012
    var fractionPart: Double {
        let fractionStr = "0.\(String(self).split(separator: ".")[1])"
        return Double(fractionStr)!
    }
    
    /// 1.0012 --> "0.0012"
    var fractionPartString: String {
        return "0.\(String(self).split(separator: ".")[1])"
    }
    
    /// 1.0012 --> 12
    var fractionPartInteger: Int {
        let fractionStr = "\(String(self).split(separator: ".")[1])"
        return Int(fractionStr)!
    }
    
}
