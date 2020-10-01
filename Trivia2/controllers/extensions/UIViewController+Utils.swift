//
//  UIViewController+Utils.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 03/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController {
    
    /*  func displayAlert(title: String, message:String){
     let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
     alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
     //show(alertVC, sender: nil)
     self.present(alertVC, animated: true)
     } */
    
    func displayAlert(title: String, message:String, handler: UIAlertAction?){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let handler = handler {
            DispatchQueue.main.async {
                alertVC.addAction(handler)
            }
        }
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
}
