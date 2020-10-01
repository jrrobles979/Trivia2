//
//  SignUpVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 19/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class SignUpVC: UIViewController {
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    
    var imagePicker:UIImagePickerController!
    var image:UIImage? = nil
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func clearForm(){
        tfUsername.text = ""
        tfEmail.text = ""
        tfPassword.text = ""
        showError(msg: "")
    }
    
    func setup(){
        showError(msg: "")
        showStatus(activity: false, status: "")
        btnCreateAccount.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnCreateAccount.backgroundColor!.cgColor)
        btnCancel.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnCreateAccount.backgroundColor!.cgColor)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        profileImageView.layer.cornerRadius = Constants.buttons_corner_radius
        profileImageView.clipsToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(showImagePicker) )
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        ref = Database.database().reference()
        
    }
    
    func validateFields() -> String?{
        if tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Plase fill all fields"
            
        }
        
        let username = tfUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isUsernameValid(username) == false{
            return "Invalid username"
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
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        showError(msg: "")
        showStatus(activity: true, status: "Creating user")
        
        let error = validateFields()
        
        if error != nil {
            self.showStatus(activity: false, status: "")
            showError(msg: error!)
            return
        }
        
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let username = tfUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        guard let imageSelected = self.image else {
            showError(msg: "Select a profile image")
            showStatus(activity: false, status: "")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            print("invalid image data")
            return
        }
        
        SessionStore.shared.signUp(email: email, password: password) {
            (result, err ) in
            if err != nil {
                self.showStatus(activity: false, status: "")
                self.showError(msg: err!.localizedDescription)
                return
            }
            FirebaseDbController.updateProfilePic(uid:result!.user.uid, imageData:imageData, completion: self.handleOnProfileSaved(profileImageUrl:error:))
        }
    }
    
    func handleOnProfileSaved(profileImageUrl:String,error:Error?){
        if let user = SessionStore.shared.getCurrentFirebaseUser() {
            FirebaseDbController.setUserDict(uid: user.uid, avatar: profileImageUrl, username:  tfUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines), email: tfEmail.text!)
            FirebaseDbController.setUser(uid: user.uid, completion: handleUserCreated(success:error:))
        } else {
            print("ups!, something went wrong")
        }
        
    }
    
    func handleUserCreated(success:Bool,error:Error?){
        showStatus(activity: false, status: "")
        if success {
            FirebaseDbController.getUser(uid: SessionStore.shared.getCurrentFirebaseUser()!.uid ){
                (userDetails) in
                if userDetails != nil {
                    Utilities.saveUserProfileOnUserDefaults8(userDetail: userDetails)
                } else {
                    print("There was an error reading created user details")
                }
            }
            self.navToTabBarController()
        } else {
            showError(msg: error?.localizedDescription ?? "There was an error saing user profile")
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func navToTabBarController(){
        performSegue(withIdentifier: Constants.sgSignUpToMain, sender: nil)
    }
    
    
    
    @objc func showImagePicker(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
}

extension SignUpVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            self.profileImageView.image = pickedImage
            self.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

