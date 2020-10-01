//
//  ResponseCodes.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation


enum ResponseCodes:Int {
    case success = 0 , no_results, invalid_param, token_not_found, token_empty, undefined_error
    var labelValue: String {
          switch self {
          case .success: return "Success"
          case .no_results: return "No Results"
          case .invalid_param: return "Invalid Parameter"
          case .token_not_found: return "Token Not Found"
          case .token_empty: return "Token Empty"
          case .undefined_error: return "Undefined Error"
          }}
    
    var description: String {
    switch self {
        case .success: return "Returned results successfully."
        case .no_results: return "Could not return results. The API doesn't have enough questions for your query. (Ex. Asking for 50 Questions in a Category that only has 20.)"
        case .invalid_param: return "Contains an invalid parameter. Arguements passed in aren't valid. (Ex. Amount = Five)"
        case .token_not_found: return "Session Token does not exist."
        case .token_empty: return "Session Token has returned all possible questions for the specified query. Resetting the Token is necessary."
        case .undefined_error: return "There was an error, see log for more details"
    }}
}
