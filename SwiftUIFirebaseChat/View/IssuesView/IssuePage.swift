//
//  IssuePage.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//

import SwiftUI

struct IssuePage: View {
    @EnvironmentObject var issueViewModel: IssueViewModel
    
    var body: some View {
        
        NavigationView {
            VStack{
                UserSelfIssueRow()
                Divider()
                IssuesGrid()
            }
            .navigationBarHidden(true)
            .task {
                issueViewModel.getDataFromFirebase()
            }
        }
    }
}

struct IssuePage_Previews: PreviewProvider {
    static var previews: some View {
        IssuePage()
        
        
    }
}
