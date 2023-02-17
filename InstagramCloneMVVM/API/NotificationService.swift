//
//  NotificationService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 17.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct NotificationService {
    
    static func uploadNotification (toUID uid: String,
                                    fromUser: User,
                                    type: NotificationType,
                                    post: Post? = nil) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUID else { return }
        
        let docRef = COLLECTION_NOTIFICATION.document(uid).collection("user-notifications").document()
        
        var data: [String : Any] = ["timeStamp" : Timestamp(date: Date()),
                                    "uid": fromUser.uid,
                                    "type": type.rawValue,
                                    "id": docRef.documentID,
                                    "userProfileImageURL": fromUser.profileImageURL,
                                    "username": fromUser.username]
        
        if let post = post {
            data["postID"] = post.postID
            data["postImageURL"] = post.imageURL
        }
        
        docRef.setData(data)

    }
    
    static func fetchNotification(completion: @escaping([Notification])-> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATION.document(uid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)
        }
        
        
    }
    
    
}
