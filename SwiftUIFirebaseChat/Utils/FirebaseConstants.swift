//
//  FirebaseConstants.swift
//  SwiftUIFirebaseChat

import Foundation
import Firebase
import FirebaseFirestore

struct FirbaseConstants: Identifiable {
    var id: ObjectIdentifier
    
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
    static let messages = "messages"
    static let recentMessages = "recentMessages"
    static let uid = "uid"
}
