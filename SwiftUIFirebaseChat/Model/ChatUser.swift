//
//  ChatUser.swift
//  SwiftUIFirebaseChat

import Foundation

struct ChatUser: Identifiable,Codable {
    
    //MARK: - Properties
    
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    //MARK: - Initialiser
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
