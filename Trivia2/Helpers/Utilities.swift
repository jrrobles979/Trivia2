//
//  Utilities.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 24/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation


class Utilities{
    
    static func isUsernameValid(_ username:String) -> Bool{
        let RegEx = "\\w{7,18}"
        let userTest = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return userTest.evaluate(with: username)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmailAddress(_ emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    static func saveUserProfileOnUserDefaults8(userDetail:[String:Any]!){
        let defaults = UserDefaults.standard
        defaults.set(userDetail, forKey: Constants.userDefaultsProfileObjectKey )
    }
        
    
    static func updateUserProfileOnUserDefaults(key:String, value:String){
        var userDetails = UserDefaults.standard.value(forKey: Constants.userDefaultsProfileObjectKey) as! [String:Any]
        userDetails.updateValue(value, forKey: key)
        saveUserProfileOnUserDefaults8(userDetail: userDetails)
    }
        
}
