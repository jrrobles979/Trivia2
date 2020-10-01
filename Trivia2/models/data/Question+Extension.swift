//
//  Question+Extension.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 28/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

extension Question {
    
    func setOptionsAsData(stringArray: [String]) -> () {
        do {
            let data = try JSONSerialization.data(withJSONObject: stringArray, options: [])
            self.options = data
        }catch {
            print("error saving options array as data")
        }
    }
    
    func getOptionsAsStringArray() -> [String]? {
        var options:[String] = []
        do {
            guard let data = self.options ,  let answers = (try JSONSerialization.jsonObject(with: data, options: [])) as? [String] else { return options }
            options.append(contentsOf: answers)
        } catch {
            print("error retrieving options array as string")
        }
        return options
    }
    
    
}
