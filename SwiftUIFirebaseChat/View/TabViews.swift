
//  TabView.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 2.05.2022.
//
import SwiftUI

struct TabViews: View {
    @StateObject private var issueVM = IssueViewModel()
    @State private var selection: Tab = .mainMessageView
    
    private enum Tab {
        case issuePage
        case mainMessageView
    }
    
    var body: some View {
        TabView(selection: $selection) {
            IssuePage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Issues")
                        .font(.title3)
                }
                .tag(Tab.issuePage)
                .environmentObject(issueVM)
               
            MainMessageView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                        .font(.largeTitle)
                }
                .tag(Tab.mainMessageView)
        }
        
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
