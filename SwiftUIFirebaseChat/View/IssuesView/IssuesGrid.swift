//
//  UsersIssuesGrid.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//
import SwiftUI

struct IssuesGrid: View {
    @EnvironmentObject var issueViewModel: IssueViewModel
    
    private var layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
   
    //MARK: - Show all posts in grid form
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(issueViewModel.sortIssue(sortBy: .date) ) {issue in
                    NavigationLink{
                        IssueDetails(issue: issue, isOwn: false)
                            .environmentObject(issueViewModel)
                    } label: {
                        IssueItem(issue: issue)
                    }
                }
            }
        }
    }
}

struct UsersIssuesGrid_Previews: PreviewProvider {
    static var previews: some View {
        IssuesGrid()
            .environmentObject(IssueViewModel())
    }
}
