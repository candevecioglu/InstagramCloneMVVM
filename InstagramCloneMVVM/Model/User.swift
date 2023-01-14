//
//  User.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 11.01.2023.
//

import Foundation
import FirebaseAuth

struct User {
    
    let email: String
    let fullname: String
    let profileImageURL: String
    let username: String
    let uid: String
    
    var isFollowed = false
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
    
}
