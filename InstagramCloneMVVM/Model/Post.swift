//
//  Post.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 29.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct Post {
    
    var caption: String
    var likes: Int
    let imageURL: String
    let ownerUID: String
    let timeStamp: Timestamp
    let postID: String
    let ownerImageURL: String
    let ownerUsername: String
    var didLike = false
    
    init(postID: String, dictionary: [String: Any]) {
        
        self.postID = postID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
