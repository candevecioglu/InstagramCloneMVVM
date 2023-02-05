//
//  UserService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 11.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

typealias FireStoreCompletion = (Error?) -> Void

struct UserService {
    
    static func fetchUser (withUID uid: String, completion: @escaping(User) -> Void) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let getDictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: getDictionary)
            completion(user)
        }
        
    }
    
    static func fetchUsers (completion: @escaping([User]) -> Void) {
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }

            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            
            completion(users)
        }
    }
    
    static func follow (uid: String, completion: @escaping(FireStoreCompletion)) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUID).setData([:], completion: completion)
        }
        
    }
    
    static func unfollow (uid: String, completion: @escaping(FireStoreCompletion)) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUID).delete(completion: completion)
            
        }
    }
    
    static func checkIfUserFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }

        COLLECTION_FOLLOWING.document(currentUID).collection("user-following").document(uid).getDocument { snapshot, error in
            
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
            
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUID", isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, following: following, posts: posts))
                }
                
            }
        }
        
    }
    
}
