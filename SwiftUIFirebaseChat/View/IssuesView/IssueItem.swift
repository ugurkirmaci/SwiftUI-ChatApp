//
//  IssueItem.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//

import SwiftUI

struct IssueItem: View {
    
    @EnvironmentObject var issueViewModel: IssueViewModel
    var issue: Issue
 
    //MARK: - Label structure where posts will be displayed on "issue Page"
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "circle.fill")
                .renderingMode(.original)
                .resizable()
                .frame(width: getScreenBounds().width * 0.25 ,
                       height: getScreenBounds().width * 0.25,
                       alignment: .center)
                .clipShape(Circle())
                .foregroundColor(.white)
                .shadow(color: issue.isAnswered ? .green: .red , radius: 10)
                
            //Programming Language text
            Text(issue.programmingLanguage)
                .frame(width: 110, height: 20, alignment: .center)
                .foregroundColor(.primary)
                .font(.footnote)
        }
        .padding(.vertical, 20)
    }
}
