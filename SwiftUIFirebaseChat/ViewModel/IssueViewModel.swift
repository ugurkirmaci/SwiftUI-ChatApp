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
    let db = Firestore.firestore()
    @ObservedObject var alertViewModel = AlertViewModel()
}


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

//Add issue item to firebase
extension IssueViewModel {
    func createNewIssue(title: String, language: String,codeSnippet: String, user: ChatUser) {
        let issueID = UUID().uuidString
        let ref = db.collection("issues").document(issueID)
        let data = ["user":["id":user.uid,
                            "email":user.email,
                            "profileImageUrl":user.profileImageUrl],
                    "title": title,
                    "programmingLanguage": language,
                    "isAnswered": false,
                    "codeSnippet":codeSnippet] as [String : Any]
        
        DispatchQueue.main.async {
            ref.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    print(CustomizedError.createError.localizedDescription)
                    self.alertViewModel.fatalError = CustomizedError.createError
                }
                self.alertViewModel.fatalError = CustomizeAlert.createSuccesful
            }
        }
    }
}

//Delete issue from firebase
extension IssueViewModel {
    func deleteIssue(issue: Issue){
        db.collection("issues").document(issue.id).delete(){ error in
            if let error = error {
                print(error.localizedDescription)
                print(CustomizedError.deleteError.localizedDescription)
                self.alertViewModel.fatalError = CustomizedError.deleteError
            }
            else {
                self.alertViewModel.fatalError = CustomizeAlert.deleteSuccessful
            }
        }
    }
}

//Update to firebase if is issue answered
extension IssueViewModel {
    func updateAnswer(issue: Issue, isAnswered: Bool){
        let referance = db.collection("issues").document(issue.id)
        referance.updateData(["isAnswered": isAnswered]) { error in
            if let err = error {
                print(err.localizedDescription)
                print(CustomizedError.answerUpdateError)
                self.alertViewModel.fatalError = CustomizedError.answerUpdateError
            }else {
                self.alertViewModel.fatalError = CustomizeAlert.answerUpdateSuccesful
            }
        }
    }
}

//Fetch data from firebase
extension IssueViewModel {
    func getDataFromFirebase(){
        db.collection("issues").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                print(CustomizedError.fetchDataError)
                self.alertViewModel.fatalError = CustomizedError.fetchDataError
                return
            }
            
            self.issuesList =  document.map { (querySnapshot) -> Issue in
                let data = querySnapshot.data()
                let id = querySnapshot.documentID
                let title = data["title"] as? String ?? ""
                let programmingLanguage = data["programmingLanguage"] as? String ?? ""
                let isAnswered = data["isAnswered"] as? Bool ?? false
                let codeSnippet = data["codeSnippet"] as? String ?? ""
                let userData = data["user"]
                return Issue(id: id,
                             user: ChatUser(data: userData as? [String : Any] ?? [:]),
                             title: title,
                             programmingLanguage: programmingLanguage,
                             codeSnippet: codeSnippet,
                             isAnswered: isAnswered)
            }
        }
    }
}
