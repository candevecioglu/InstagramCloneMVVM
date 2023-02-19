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
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS.whereField("ownerUID", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map( { Post(postID: $0.documentID, dictionary: $0.data()) } )
            posts.sort { (post1, post2) -> Bool in
                return post1.timeStamp.seconds > post2.timeStamp.seconds
            }
            
            completion(posts)
        }
    }
    
    static func fetchPost(withPostID postID: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postID).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postID: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    
    static func likePost(post: Post, completion: @escaping(FireStoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes" : post.likes + 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    static func unlikePost(post: Post, completion: @escaping(FireStoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes" : post.likes - 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).delete(completion: completion)
        }
        
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
        
    }
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostID: document.documentID) { post in
                    posts.append(post)
                    completion(posts)
                }
            })
        }
    }
    
    static func updateUserFeedAfterFollowing(user: User) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_POSTS.whereField("ownerUID", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let docIDs = documents.map( {$0.documentID })
            
            docIDs.forEach { id in
                COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([ : ])
            }
            
        }

    }
    
}
