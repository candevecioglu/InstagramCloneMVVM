//
//  UserService.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 11.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

struct UserService {
    
    static func fetchUser (completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
    
    
    
}
