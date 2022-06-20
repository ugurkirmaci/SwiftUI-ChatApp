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
    @State var description = ""
    @Binding var isShowNewIssuePage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            
            
            //MARK: - Text Labels
            VStack {
                Group{
                    HStack {
                        Text("From: ")
                            .frame(width: getScreenBounds().width * 0.2,
                                   height: getScreenBounds().height * 0.05,
                                   alignment: .leading)
                            .foregroundColor(.red)
                        Text(email)
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
            
            NavigationLink {
                CodeSnippetTextEditor(textEditor: $codeSnippet)
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: getScreenBounds().width * 0.1,
                           height: getScreenBounds().width * 0.1)
                    .padding()
            }
            Divider()
            HStack {
                Text("Description")
                    .frame(height: getScreenBounds().height * 0.05,
                           alignment: .leading)
                    .foregroundColor(.red)
                Image(systemName: "arrow.turn.right.down")
                    .frame(height: getScreenBounds().height * 0.05)
                Spacer()
            }
            TextEditor(text: $description)
                .frame(width: getScreenBounds().width * 0.9,
                       height: getScreenBounds().height * 0.3,
                       alignment: .center)
                .lineSpacing(10)
                .border(.secondary)
                .multilineTextAlignment(.leading)
                .font(.footnote)
            
            
            //MARK: - Create Button
            HStack {
                Spacer()
                CreateButton(isShowNewIssuePage: $isShowNewIssuePage, title: title, language: language, codeSnippet: codeSnippet, description: description )
                
                Spacer()
            }//: HStack Create Button
            .padding()
            Spacer()
        }//:VStack
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //MARK: -  Cancel Button
            Button {
                isShowNewIssuePage = false
            } label: {
                Text("Cancel")
            }
        }
    }
}

struct NewIssue_Previews: PreviewProvider {
    @State static var binding = false
    static var previews: some View {
        NewIssue(email: "Email", isShowNewIssuePage: $binding)
    }
}
