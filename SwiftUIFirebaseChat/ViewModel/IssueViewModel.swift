//
//  IssueViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 22.04.2022.
//

import Foundation
import SwiftUI
import Firebase
class IssueViewModel: ObservableObject {
    
    @Published var issuesList: [Issue] = []
    @Published var selectedIssue: Issue?
    
    let db = Firestore.firestore()
    
}

//MARK: - Check Answered
//Check if issue is answered
extension IssueViewModel {
    func isAnswered(id: String) -> Bool {
        for element in issuesList {
            if element.id == id && element.isAnswered {
                return true
            }
        }
        return false
    }
}

//MARK: - Create Issue
//Add issue item to firebase
extension IssueViewModel {
    func createNewIssue(title: String, language: String,codeSnippet: String,description: String, user: ChatUser) {
        let issueID = UUID().uuidString
        let ref = db.collection("issues").document(issueID)
        let data = ["user":["id":user.uid,
                            "email":user.email,
                            "profileImageUrl":user.profileImageUrl],
                    "title": title,
                    "programmingLanguage": language,
                    "isAnswered": false,
                    "codeSnippet":codeSnippet,
                    "description": description,
                    "date": Date.now.formatted(date: .long, time: .shortened)] as [String : Any]
        
        DispatchQueue.main.async {
            ref.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - Delete Issue
//Delete issue from firebase
extension IssueViewModel {
    func deleteIssue(issue: Issue){
        db.collection("issues").document(issue.id).delete(){ error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Update Answer
//Update to firebase if is issue answered
extension IssueViewModel {
    func updateAnswer(issue: Issue, isAnswered: Bool){
        let referance = db.collection("issues").document(issue.id)
        referance.updateData(["isAnswered": isAnswered]) { error in
            if let err = error {
                print(err.localizedDescription)
            }
        }
    }
}

//MARK: - Fetch Data
//Fetch data from firebase
extension IssueViewModel {
    func getDataFromFirebase(){
        db.collection("issues").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            
            self.issuesList =  document.map { (querySnapshot) -> Issue in
                let data = querySnapshot.data()
                let id = querySnapshot.documentID
                let title = data["title"] as? String ?? ""
                let programmingLanguage = data["programmingLanguage"] as? String ?? ""
                let isAnswered = data["isAnswered"] as? Bool ?? false
                let codeSnippet = data["codeSnippet"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let date = data["date"] as? String ?? ""
                let userData = data["user"]
                return Issue(id: id,
                             user: ChatUser(data: userData as? [String : Any] ?? [:]),
                             title: title,
                             programmingLanguage: programmingLanguage,
                             codeSnippet: codeSnippet,
                             isAnswered: isAnswered,
                             description: description,
                             date: date)
            }
        }
    }
}
