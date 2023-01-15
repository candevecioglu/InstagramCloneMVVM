//
//  Constants.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 11.01.2023.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuthInterop


let COLLECTION_USERS =  Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
