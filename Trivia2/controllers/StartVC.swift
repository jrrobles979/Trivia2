//
//  StartVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 18/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class StartVC: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
      
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        btnSignUp.roundedCorners(cornerRadius: Constants.buttons_corner_radius, borderWidth: Constants.buttons_border_width,
                                 borderColor: TriviaTheme.Colors.redPink.color.cgColor)
        btnLogin.roundedCorners(cornerRadius: Constants.buttons_corner_radius, borderWidth: Constants.buttons_border_width,
                                borderColor: TriviaTheme.Colors.redPink.color.cgColor)
   
   
        if  Auth.auth().currentUser != nil {
            performSegue(withIdentifier: Constants.sgToMain, sender: nil)
        } else{
            stackView.alpha = 1
        }
        
                
    }
    
    
}
