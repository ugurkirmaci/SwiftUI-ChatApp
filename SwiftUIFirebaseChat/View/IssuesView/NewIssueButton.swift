//
//  CreatNewIssue.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
struct NewIssueButton: View {
    @State var isShowNewIssuePage = false
    @ObservedObject var userViewModel = MainMessageViewModel()
    var defaultImage = UIImage(systemName: "star")
    
    var body: some View {
        VStack {
            //MARK: - Image
            ZStack(alignment: .bottomTrailing){
                WebImage(url: URL(string: userViewModel.chatUser?.profileImageUrl ?? ""))
                    .renderingMode(.original)
                    .resizable()
                    .placeholder(content: {
                        ProgressView()
                    })
                    .frame(width: getScreenBounds().width * 0.20,
                           height: getScreenBounds().width * 0.20,
                           alignment: .center)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                
                //MARK: - PLUS(+) BUTTON
                Button {
                    isShowNewIssuePage = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .background(Color.white)
                        .clipShape(Circle())
                        .frame(width: getScreenBounds().width * 0.08,
                               height: getScreenBounds().width * 0.08)
                        .foregroundColor(.blue)
                }
            }//:ZStack
            
            //MARK: - New Issue Text
            Text("Crete Issue")
                .font(.title2)
                .opacity(0.5)
            
            NavigationLink("", isActive: $isShowNewIssuePage) {
                NewIssue(email: userViewModel.chatUser?.email ?? "", isShowNewIssuePage: $isShowNewIssuePage)
                    .environmentObject(MainMessageViewModel())
            }
        }//:VStack
        .padding()
        
    }
}

struct CreatNewIssue_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewIssueButton()
            
        }
    }
}
