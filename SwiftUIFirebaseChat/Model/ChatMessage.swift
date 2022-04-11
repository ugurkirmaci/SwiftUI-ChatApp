//
//  ChatMessage.swift
//  SwiftUIFirebaseChat


import Foundation
import FirebaseFirestoreSwift

//mesajlarimiz aldigimiz firebase datastore
struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
