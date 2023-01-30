//
//  PostService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 29.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthInterop
import FirebaseCore

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FireStoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadPostImage(image: image) { imageURL in
            
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageURL": imageURL,
                        "ownerUID": uid,
                        "ownerImageURL": user.profileImageURL,
                        "ownerUsername": user.username] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
        
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map( { Post(postID: $0.documentID, dictionary: $0.data()) } )
            completion(posts)
        }
    }
    
}
