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
        VStack {
            VStack(spacing: 5) {
                Text("From:  \(issue.user.email)" )
                    .frame(width: textFrameWidth ,
                           height: textFrameHeight,
                           alignment: .leading)
                
                Text("Title: \(issue.title)")
                    .frame(width: textFrameWidth ,
                           height: textFrameHeight,
                           alignment: .leading)
                
                Text("Language: \(issue.programmingLanguage)")
                    .frame(width: textFrameWidth ,
                           height: textFrameHeight,
                           alignment: .leading)                
            }
            Divider()
            //Kod parçacığı butonu ve kod texti eklenecek
            //            Text(issue.codeSnippet)
            //                .frame(width: getScreenBounds().width * 0.9,
            //                       height: getScreenBounds().height * 0.6,
            //                       alignment: .center)
            
           
            NavigationLink {
                CodeSnippet(codeSnippetString: issue.codeSnippet )
            } label: {
               
                    Image(systemName: "c.square.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    Image(systemName: "o.square.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    Image(systemName: "d.square.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    Image(systemName: "e.square.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                
            }

            Spacer()
            
        }//:VStack
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                // Clicked checkmark button
                // succes -> answer changed
                // fail -> show error message
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
                    Button(role: .destructive) {
                        issueViewModel.deleteIssue(issue: issue)
                    } label: {
                        Text("YES")
                    }
                    Button(role: .cancel) {
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
    
    private var textFrameWidth: CGFloat {
        getScreenBounds().width * 0.85
    }
    private var textFrameHeight: CGFloat {
        getScreenBounds().height * 0.05
    }
    
}
