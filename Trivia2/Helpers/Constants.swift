//
//  Constants.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 18/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
import SwiftUI

class Constants {
    
    static let autoSaveInterval:Double = 30
    static let answer_time_countdown:Int = 10000
    static let between_question_time_countdown:Int = 5000
    static let allCategories = CategoryResponse(id:-1, name:"All Categories" )
    static let next_questions_label:[String] = [
    "Something wicked this way comes", "do you feel lucky?, punk!",
    "do or do not, there is no try", "The only true wisdom is in knowing you know nothing"
    ]
    static let on_game_music = "ssm-102518-prominent-question"
    static let on_waiting_music = "waiting-30-sec-edit_GkZMoHBu"
    static let winner = "fanfare-short-bonus_M14MIrVu"
    static let loser = "jg-032316-sfx-video-game-game-over-4"
    static let buttons_corner_radius = CGFloat(5)
    static let buttons_border_width =  CGFloat(1)
    
    static let homeTabBarController = "homeTabBarController"
    static let sgToMain = "sgToMain"
    static let sgLoginToMain = "sgLoginToMain"
    static let sgSignUpToMain = "sgSignUpToMain"
    static let startNavController = "startNavController"
    static let firebaseStorageUrl  = "gs://trivia2udacity.appspot.com"
    static let firebaseMetadataContentType = "image/jpg"
    static let userDefaultsProfileObjectKey = "profile"
    
}
