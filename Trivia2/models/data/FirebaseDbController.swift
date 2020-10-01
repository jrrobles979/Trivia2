//
//  FirebaseDbController.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 30/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase




class FirebaseDbController {
    static private let shared = Database.database().reference()
    static let userStorage = "users"
    static let storageFolder = "profile"
    static let userNameObjectKey = "username"
    static let emailObjectKey = "email"
    static let userIdObjectKey = "userid"
    static let avatarObjectKey = "avatar"
    static var userDict:Dictionary<String,Any> = [
        "username":"",
        "email": "",
        "userid": "" ,
        "avatar": ""
    ]
    
    
    static func setUserDict(uid:String, avatar:String, username:String, email:String){
        userDict.updateValue(username, forKey: userNameObjectKey)
        userDict.updateValue(email, forKey: emailObjectKey)
        userDict.updateValue(uid, forKey: userIdObjectKey)
        userDict.updateValue(avatar, forKey: avatarObjectKey)
    }
    
    static func setUser(uid:String, completion:@escaping(Bool,Error?)->Void){       
        shared.child(FirebaseDbController.userStorage).child(uid).updateChildValues(userDict, withCompletionBlock: {
            (error, ref) in
            if error == nil {
                completion(true,nil)
            } else {
                completion(false,error)
            }
        }
        )
    }
    
    
    
    static func getUser(uid:String, completion:@escaping([String:Any]?)->Void ) {
        shared.child(FirebaseDbController.userStorage).child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{
                completion(nil)
                return
            }
            completion(value)
            
        })
    }
    
    
    static func updateProfilePic(uid:String, imageData:Data, completion:@escaping(String ,Error?)->Void ){
        let storageRef =  Storage.storage().reference(forURL: Constants.firebaseStorageUrl )
        let storageProfileRef  = storageRef.child(storageFolder).child(  uid )
        let metadata = StorageMetadata()
        metadata.contentType = Constants.firebaseMetadataContentType
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                completion("" , error)
            } else {
                storageProfileRef.downloadURL(){
                    (url,err) in
                    if let metaImageUrl = url?.absoluteString {
                        //dict.updateValue(metaImageUrl, forKey: "avatar")
                        completion( metaImageUrl, nil)
                    } else if err != nil {
                        completion("" , err)
                    }
                    
                }
            }
        }
    }
    
}
