//
//  FirebaseSessionStore.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 15/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore: ObservableObject {
    static let shared = SessionStore.init()
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet{self.didChange.send(self)}}
    var handle: AuthStateDidChangeListenerHandle?
    
    func signUp(email:String, password:String, handler:@escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email:String, password:String, handler:@escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func getCurrentFirebaseUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    func signOut() -> Bool
    {
        var success = false
        do{
            try Auth.auth().signOut()
            self.session = nil
            success = true
        } catch {
            print("Error signing out...")
        }
        return success
    }
    
    func reAuthenticate(email:String, password:String, completion:@escaping(Bool, Error?)->Void   ){
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential) {
            res,error in
            if  error != nil {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func updatePassword(password:String, completion: @escaping(Bool,Error?)->Void){
        
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if(error != nil) {
                completion(false, error)
            } else  {
                completion(true, nil)
            }
        }
    }
        
        func unbind(){
            if let handle = handle{
                // Auth.auth().removeStateDidChangeListener(handle)
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
        
        deinit {
            unbind()
        }
        
    }
    
    
    struct User{
        var uid:String
        var email:String
        init(uid:String, email:String){
            self.uid=uid
            self.email=email
        }
        
}
