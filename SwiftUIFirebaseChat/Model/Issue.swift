//
//  Issue.swift
//  SwiftUIFirebaseChat
//
//
import Foundation

struct Issue:Decodable, Identifiable{
    let id: String
    let user: ChatUser
    let title: String
    let programmingLanguage: String
    let codeSnippet: String
    let isAnswered: Bool
    let description: String
    let date: String
}
