//
//  Issue.swift
//  SwiftUIFirebaseChat
//
//
import Foundation

struct Issue: Identifiable{
    let id: String
    let user: ChatUser
    let title: String
    let programmingLanguage: String
    let codeSnippet: String
    let isAnswered: Bool
}
