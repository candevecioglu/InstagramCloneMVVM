//
//  CommentService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 4.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct CommentService {
    
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FireStoreCompletion)) {
        
        let data: [String : Any] = ["uid" : user.uid,
                                    "comment" : comment,
                                    "timeStamp" : Timestamp(date: Date()),
                                    "username" : user.username,
                                    "profileImageURL" : user.profileImageURL]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
        
    }
    
    static func fetchComment(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        
        var comments = [Comment]()
        
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
            
        }
        
    }
    
}
