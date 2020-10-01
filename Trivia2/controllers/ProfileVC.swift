//
//  ProfileVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 26/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnCloseSession: UIButton!
    var imagePicker:UIImagePickerController!
    // var image:UIImage? = nil
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if let userDetail = UserDefaults.standard.object(forKey: Constants.userDefaultsProfileObjectKey) as? [String:Any] {
            //userDict = userDetail
            FirebaseDbController.userDict = userDetail
        } else {
            showError(msg: "User profile not found")
            return
        }
        loadUserDetail()
    }
    
    func loadProfileImage(url:URL){
        showStatus(activity: true, status: "Loading profile image")
        ApiManager.loadProfileImage(url: url, completion: handleProfileImageFetched(data:error:))
    }
    
    func handleProfileImageFetched(data:Data?,error:Error?){
        showStatus(activity: false, status: "")
        if error != nil {
            showStatus(activity: false, status: "")
            showError(msg: "Profile image not found")
            return
        }
        profileImageView.image = UIImage(data: data!)
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        showCloseSessionAlert()
    }
    
    func setup(){
        showStatus(activity: false, status: "")
        showError(msg: "")
        btnUpdate.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnUpdate.backgroundColor!.cgColor
        )
        
        btnCloseSession.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: btnCloseSession.backgroundColor!.cgColor
        )
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        profileImageView.layer.cornerRadius = Constants.buttons_corner_radius
        profileImageView.clipsToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(showImagePicker) )
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    func loadUserDetail(){
        if let username = FirebaseDbController.userDict[FirebaseDbController.userNameObjectKey] as? String {
            lblUsername.text = username
        }
        
        if let email = FirebaseDbController.userDict[FirebaseDbController.emailObjectKey] as? String {
            tfEmail.text = email
        }
        
        if let avatar = FirebaseDbController.userDict[FirebaseDbController.avatarObjectKey] as? String {
            guard let profileUrl = URL(string: avatar) else {
                showStatus(activity: false, status: "")
                showError(msg: "Profile image not found")
                return
            }
            loadProfileImage(url: profileUrl)
        }
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
    
    @objc func showImagePicker(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func showCloseSessionAlert() {
        let alert = UIAlertController(title: "Close session?", message: "Are you sure you want to close session? You will lose all your game history", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Close Session", style: .destructive, handler: {(alert: UIAlertAction!) in //self.deleteAllRecords()
            DataController.reset(entity: Game.self)
            self.closeSession()
            
        } )
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showUpdatePassword(){
        let alert = UIAlertController(title: "Password updated", message: "your password has been updated successfully, would you like to close your current session?, You will lose all your game history", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Close Session", style: .destructive, handler: {(alert: UIAlertAction!) in //self.deleteAllRecords()
            DataController.reset(entity: Game.self)
            self.closeSession()
            
        } )
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    func closeSession(){
        
        if SessionStore.shared.signOut() {
            let startNavController = storyboard?.instantiateViewController(identifier: Constants.startNavController) as? UINavigationController
            view.window?.rootViewController = startNavController
            view.window?.makeKeyAndVisible()
            UserDefaults.standard.removeObject(forKey: Constants.userDefaultsProfileObjectKey)
            
        } else
        {
            showStatus(activity: false, status: "")
            showError(msg: "Error signing out")
        }
        
    }
    
    
    @IBAction func updatePasswordTapped(_ sender: Any) {
        showError(msg: "")
        
        let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let oldPassword = tfOldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = tfNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(email == "" ){
            showError(msg: "Email not found")
            return
        }
        
        if oldPassword == "" && newPassword == "" {
            return
        }
        
        if oldPassword!.count>0 && newPassword == "" {
            showError(msg: "Input new password")
            return
        }
        
        if oldPassword == "" && newPassword!.count>0 {
            showError(msg: "Input old password")
            return
        }
        
        if Utilities.isPasswordValid(newPassword!) == false {
         showError(msg: "Check your password is at least 8 characters, and contains a special character and a number")
         return
         }
        
        SessionStore.shared.reAuthenticate(email: email!, password: oldPassword!) {
            success, error in
            if error != nil {
                self.showStatus(activity: false, status: "")
                self.showError(msg: error!.localizedDescription)
            } else {
                SessionStore.shared.updatePassword(password: newPassword!) {
                    success, updatePasswordError in
                    self.showStatus(activity: false, status: "")
                    if updatePasswordError != nil {
                        self.showError(msg: updatePasswordError!.localizedDescription)
                        return
                    }
                    self.showUpdatePassword()
                }
            }
        }
        showStatus(activity: true, status: "Updating password")
    }
    
    
    
}

extension ProfileVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            guard let imageData = pickedImage.jpegData(compressionQuality: 0.4) else {
                print("invalid image data")
                showStatus(activity: false, status: "")
                showError(msg: "Profile image not found")
                return
            }
            FirebaseDbController.updateProfilePic(uid:  SessionStore.shared.getCurrentFirebaseUser()!.uid , imageData: imageData, completion: handleProfileImageUpdated(url:error:))
            self.showStatus(activity: true, status: "Updating profile picture")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func handleProfileImageUpdated(url:String,error:Error?){
        print(url)
        showStatus(activity: false, status: "")
        guard let profileUrl = URL(string: url) else {
            showStatus(activity: false, status: "")
            showError(msg: "Profile image not found")
            return
        }
        //actualizar el userdetails
        loadProfileImage(url:profileUrl)
        FirebaseDbController.userDict.updateValue(url, forKey: FirebaseDbController.avatarObjectKey)
        FirebaseDbController.setUser(uid: SessionStore.shared.getCurrentFirebaseUser()!.uid){
            (success, error) in
            self.showStatus(activity: false, status: "")
            if error != nil
            {
                self.showError(msg: "Profile image not updated correctly")
            }else {
                Utilities.updateUserProfileOnUserDefaults(key:FirebaseDbController.avatarObjectKey, value:url)
            }
        }
    }
    
    
}
