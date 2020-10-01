//
//  SignInVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 18/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSingIn: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func clearForm(){
        tfEmail.text = ""
        tfPassword.text = ""
        showError(msg: "")
    }
    
    func setup(){
        showError(msg: "")
        showStatus(activity: false, status: "")
        btnSingIn.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnSingIn.backgroundColor!.cgColor
        )
        btnCancel.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnSingIn.backgroundColor!.cgColor
        )
    }
    
    
    func validateFields() -> String?{
        if
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Plase fill all fields"
            
        }
        
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmailAddress(email) == false{
            return "Invalid email address"
        }
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(password) == false{
            return "Check your password is at least 8 characters, and contains a special character and a number"
        }
        return nil
        
    }
    
    func showError(msg:String){
        let error = msg.trimmingCharacters(in: .whitespacesAndNewlines)
        lblError.text = error
        lblError.isHidden = (lblError.text!.count > 0 ? false : true)
    }
    
    func showStatus(activity:Bool, status:String ){
        let msg = status.trimmingCharacters(in: .whitespacesAndNewlines)
        if activity == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        activityIndicator.isHidden =  !activityIndicator.isAnimating
        lblStatus.text = msg
        lblStatus.isHidden = ( lblStatus.text!.count > 0 ? false : true )
        
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        showError(msg: "")
        showStatus(activity:true, status:"Signing in" )
       /* let error = validateFields()
        
        if error != nil {
            showError(msg: error!)
            showStatus(activity: false, status: "")
            return
        }*/
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        SessionStore.shared.signIn(email: email, password: password){
            (result, err ) in
                   if err != nil {
                       self.showStatus(activity: false, status: "")
                       self.showError( msg: err!.localizedDescription )
                   } else{
                       self.getUserProfile()
                   }
        }
    }
    

    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func navToTabBarController(){
        performSegue(withIdentifier: Constants.sgLoginToMain, sender: nil)
        /*  let homeTabBarController = storyboard?.instantiateViewController(identifier: Constants.homeTabBarController) as? UITabBarController
         
         view.window?.rootViewController = homeTabBarController
         view.window?.makeKeyAndVisible() */
    }
    
    func getUserProfile(){
         FirebaseDbController.getUser(uid: Auth.auth().currentUser!.uid, completion:handleGetUser(userDetail:) )
    }
    
    func handleGetUser(userDetail:[String:Any]?){
           showStatus(activity: true, status: "Loading profile")
           guard let userDetail = userDetail else{
               showError(msg: "User profile not found")
               return
        }
        showStatus(activity: false, status: "")
        Utilities.saveUserProfileOnUserDefaults8(userDetail: userDetail)
        navToTabBarController()
       }
    
    
    
}
