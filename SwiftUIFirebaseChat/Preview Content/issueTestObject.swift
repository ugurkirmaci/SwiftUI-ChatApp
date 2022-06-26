//
//  issueTestObject.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 26.06.2022.
//

import Foundation

class issueTestObject {
   let issue1 = Issue(id: "", user: ChatUser(data: ["tolga":""]), title: "title", programmingLanguage: "c++", codeSnippet: "code", isAnswered: false, description: "description", date: "date")
    static var share = issueTestObject()
    init(){}
}
