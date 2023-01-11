//
//  AuthService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 9.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: @escaping ((AuthDataResult?, (any Error)?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String:Any] = ["email" : credentials.email,
                                          "fullname" : credentials.fullname,
                                          "profileImageURL" : imageURL,
                                          "uid" : uid,
                                          "username" : credentials.username]
                
               COLLECTION_USERS.document(uid).setData(data, completion: completion)
                
            }
        }
    }
    
}
