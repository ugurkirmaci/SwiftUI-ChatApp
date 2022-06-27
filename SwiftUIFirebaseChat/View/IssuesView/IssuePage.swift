//
//  IssuePage.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//

import SwiftUI

struct IssuePage: View {
    @EnvironmentObject var issueViewModel: IssueViewModel
    @State var issueSortByPickerSelection: IssueSortBy = .Date
    var body: some View {
        NavigationView {
            VStack{
                UserSelfIssueRow()
                Divider()
                IssuesGrid(issueListSortedBy: $issueSortByPickerSelection)
                    .environmentObject(issueViewModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                issueViewModel.getDataFromFirebase()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("Sort by:")
                        IssueSortPicker(selection: $issueSortByPickerSelection)
                    }.font(.title2)
                }
            }
        }
    }
}

struct IssuePage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IssuePage()
//            IssuePage()
//                .previewDevice("iPhone 8")
        } .environmentObject(IssueViewModel())
    }
}
