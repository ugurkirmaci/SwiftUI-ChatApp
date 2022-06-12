//
//  CreateButton.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 30.05.2022.
//

import SwiftUI
struct CreateButton: View {
    @ObservedObject var user = MainMessageViewModel()
    @EnvironmentObject var viewModel: IssueViewModel
    @ObservedObject var errorviewModel = AlertViewModel()
    @State var isShowCreateNewIssueAlert :Bool = false
    @State var isEmptyLabel: Bool = false
    @Binding var isShowNewIssuePage: Bool
    
    let title: String
    let language: String
    let codeSnippet: String
    
    
    var body: some View {
        // Clicked create button
        // if labels are empty -> show 'label emty' alert
        // not empty -> show confirmation 'create new issue' alert
        // if answer is yes -> try create issue
        // succes -> create issue and go to homepage
        // fail -> show error message
        Button {
            if title == "" || language == "" {
                isEmptyLabel = true
            }
            else {
                isShowCreateNewIssueAlert = true
              
            }
        } label: {
            Text("Create")
        }
        .alert(Text("Create New Issue?"), isPresented: $isShowCreateNewIssueAlert) {
            Button("YES", role: .cancel) {
                
                
                viewModel.createNewIssue(title: title,
                                         language: language,
                                         codeSnippet: codeSnippet,
                                         user: user.chatUser!)
                
                isShowCreateNewIssueAlert = false
                isShowNewIssuePage = false
            }
            Button("NO", role: .destructive) {
                print(errorviewModel.isShowAlert)
                errorviewModel.isShowAlert = true
              
            }
        }
        .alert("Labels can not be empty", isPresented: $isEmptyLabel) {}
        .alert(errorviewModel.fatalError?.localizedDescription ?? "Unknown Error", isPresented: $errorviewModel.isShowAlert) {
            Button {
                errorviewModel.fatalError = nil
                errorviewModel.isShowAlert = false
            } label: {
                Text("OK")
            }
        }
    }
}

struct CreateButton_Previews: PreviewProvider {
    @State static var test: Bool = false
    static var previews: some View {
        CreateButton(isShowNewIssuePage: $test, title: "Title", language: "Language", codeSnippet: "" )
    }
}
