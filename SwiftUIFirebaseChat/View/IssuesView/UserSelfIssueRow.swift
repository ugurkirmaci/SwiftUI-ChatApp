//  UserSelfIssueRow.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//
import SwiftUI
import FirebaseAuth
struct UserSelfIssueRow: View {
    @EnvironmentObject var issueViewModel: IssueViewModel
    @State var isActiveNavigation = false
    
    private var filteredIssueList: [Issue] {
        return issueViewModel.issuesList.filter { $0.user.email == Auth.auth().currentUser?.email }
    }

    var body: some View {
        HStack(alignment: .center) {
            NewIssueButton()
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 5) {
                    if !(filteredIssueList.count == 0) {
                        ForEach (filteredIssueList){ issue  in
                            NavigationLink {
                                IssueDetails(issue: issue, isOwn: true)
                                    .environmentObject(issueViewModel)
                            } label: {
                                IssueItem(issue: issue, isOwnIssue: true)
                            }
                        }
                    }
                    else {
                     
                        Text("List is Empty")
                            .padding()
                    }
                }
            }//:ScroolView
        }//:HStack
        .frame(height: getScreenBounds().height * 0.2 , alignment: .center)
        
    }
}

struct UserSelfIssueRow_Previews: PreviewProvider {
    static var previews: some View {
        UserSelfIssueRow()
    }
}
