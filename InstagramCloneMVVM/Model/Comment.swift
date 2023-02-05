//
//  Comment.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 4.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct Comment {
    
    let uid: String
    let username: String
    let profileImageURL: String
    let timeStamp: Timestamp
    let comment: String
    
    init(dictionary: [String : Any]) {
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.comment = dictionary["comment"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
    }
    
}
