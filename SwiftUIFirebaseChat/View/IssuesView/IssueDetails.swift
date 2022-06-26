//
//  NewIssue.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 13.05.2022.
//

import SwiftUI
struct IssueDetails: View {
    @EnvironmentObject var issueViewModel: IssueViewModel
    @State var isAnswered = false
    @State var deleteAlert = false
    var issue: Issue
    var isOwn: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: - Text Labels
            Group{
                HStack {
                    Text("From: ")
                        .frame(width: getScreenBounds().width * 0.2,
                               height: getScreenBounds().height * 0.05,
                               alignment: .leading)
                        .foregroundColor(.red)
                    Text(issue.user.email)
                        .frame(width: getScreenBounds().width * 0.7,
                               height: getScreenBounds().height * 0.05,
                               alignment: Alignment.leading)
                }
                HStack{
                    Text("Title: ")
                        .frame(width: getScreenBounds().width * 0.2
                               , height: getScreenBounds().height * 0.05,
                               alignment: .leading)
                        .foregroundColor(.red)
                    Text(issue.title)
                        .frame(width: getScreenBounds().width * 0.7,
                               height: getScreenBounds().height * 0.05,
                               alignment: Alignment.leading)
                }
                HStack{
                    Text("Language:")
                        .frame(width: getScreenBounds().width * 0.2,
                               height: getScreenBounds().height * 0.05,
                               alignment: .leading)
                        .foregroundColor(.red)
                    Text(issue.programmingLanguage)
                        .frame(width: getScreenBounds().width * 0.7,
                               height: getScreenBounds().height * 0.05,
                               alignment: Alignment.leading)
                }
            }
            Divider()
            
            //MARK: - CodeSnippet Navigation Link
            HStack {
                Text("Code Snippet")
                    .foregroundColor(.blue)
                
                NavigationLink {
                    CodeSnippet(codeSnippetString: issue.codeSnippet)
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: getScreenBounds().width * 0.1,
                               height: getScreenBounds().width * 0.1)
                        .padding()
                }
            }
            Divider()
            //MARK: - Description text label
            HStack{
                Text("Description")
                    .frame(height: getScreenBounds().height * 0.05,
                           alignment: .leading)
                    .foregroundColor(.red)
                Image(systemName: "arrow.turn.right.down")
                    .frame(height: getScreenBounds().height * 0.05)
                
            }
            Text(issue.description)
                .frame(width: getScreenBounds().width * 0.9,
                       height: .none,
                       alignment: .leading)
            Spacer()
            
        }//:VStack
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                //MARK: - Checkmark Button
                //if user clicked own issues show checkmark button
                //Clicked checkmark button
                Button {
                    isAnswered.toggle()
                    issueViewModel.updateAnswer(issue: issue,isAnswered: isAnswered)
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(isAnswered ? .green: .red)
                        .isHidden(!isOwn)
                }
                .disabled(!isOwn)
                
                //MARK: - TRASH BUTTON
                //if user clicked own issues show trash button
                // 1) Clicked trash button
                // 2) Show confirmation alert
                // 3) if answer is yes -> try delete issue
                // 4.1) succes -> delete issue and go to homepage
                // 4.2) fail -> show error message
                Button {
                    //Action
                    deleteAlert = true
                    
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .isHidden(!isOwn)
                }
                .disabled(!isOwn)
                .alert(Text("The post will be deleted. Are you sure?") ,isPresented: $deleteAlert) {
                    Button(role: .cancel) {
                        issueViewModel.deleteIssue(issue: issue)
                    } label: {
                        Text("YES")
                    }
                    Button(role: .destructive) {
                        deleteAlert = false
                    } label: {
                        Text("NO")
                    }
                }
            }
        })//:Toolbar
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            isAnswered = issue.isAnswered
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetails(issue: issueTestObject.share.issue1, isOwn: false)
            .environmentObject(IssueViewModel())
    }
}
