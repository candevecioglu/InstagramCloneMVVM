//
//  Notification.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 5.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like   : return " liked your post."
        case .follow : return " started following you."
        case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    
    let uid: String
    var postImageURL: String?
    var postID: String?
    let timeStamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageURL: String
    let username: String
    var userIsFollowed = false
    
    init(dictionary: [String : Any]) {
        self.timeStamp           = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id                  = dictionary["id"] as? String ?? ""
        self.uid                 = dictionary["uid"] as? String ?? ""
        self.postID              = dictionary["postID"] as? String ?? ""
        self.postImageURL        = dictionary["postImageURL"] as? String ?? ""
        self.type                = NotificationType(rawValue : dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageURL = dictionary["userProfileImageURL"] as? String ?? ""
        self.username            = dictionary["username"] as? String ?? ""

    }
}
