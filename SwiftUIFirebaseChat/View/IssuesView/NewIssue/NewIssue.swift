//
//  NewIssue.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 22.05.2022.
//

import SwiftUI

struct NewIssue: View {
    
    var email: String
    @State var title = ""
    @State var language = ""
    @State var codeSnippet = ""
    @Binding var isShowNewIssuePage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            
            //MARK: -  Cancel Button
            HStack {
                Spacer()
                Button {
                    isShowNewIssuePage = false
                } label: {
                    Text("Cancel")
                }
            }.padding(.top,20)
            
            //MARK: - Text Labels
            VStack {
                Group{
                    HStack {
                        Text("From: ")
                            .frame(width: getScreenBounds().width * 0.2,
                                   height: getScreenBounds().height * 0.05,
                                   alignment: .leading)
                            .foregroundColor(.red)
                        Text("Email")
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
                        TextField("Algorithm, Progamming", text: $title)
                            .frame(width: getScreenBounds().width * 0.7,
                                   height: getScreenBounds().height * 0.05,
                                   alignment: Alignment.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    
                    HStack{
                        Text("Language:")
                            .frame(width: getScreenBounds().width * 0.2,
                                   height: getScreenBounds().height * 0.05,
                                   alignment: .leading)
                            .foregroundColor(.red)
                        TextField("Java,C++,Python", text: $language)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            Divider()
            CodeSnippetTextEditor(textEditor: $codeSnippet)
            
            //MARK: - Create Button
            HStack {
                Spacer()
                CreateButton(isShowNewIssuePage: $isShowNewIssuePage, title: title, language: language, codeSnippet: codeSnippet)
                
                Spacer()
            }//: HStack Create Button
            .padding()
            
        }//:VStack
        .padding()
        .navigationBarHidden(true)
    }
}

struct NewIssue_Previews: PreviewProvider {
    @State static var binding = false
    static var previews: some View {
        NewIssue(email: "Email", isShowNewIssuePage: $binding)
        
        
    }
}
