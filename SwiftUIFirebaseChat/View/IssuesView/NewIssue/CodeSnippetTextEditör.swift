//  CodeSnippetTextEditor.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 30.05.2022.
//
import SwiftUI

struct CodeSnippetTextEditor: View {
    @Binding var textEditor: String
    @State var isShowInfo = false
    
    let textRules = ["Copy and paste your code",
                     "After pasting your code, you can go back with back button",
                     "Automatic code formater will be activated",
                     "Editing is not possible after creating a post."]
    var body: some View {
        
        VStack {
            if isShowInfo {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(textRules, id:\.self){item in
                        Text(item)
                            .bold()
                    }
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(30)
                .foregroundColor(.white)
                .font(.body)
                
            }
            else {
                TextEditor(text: $textEditor)
                    .frame(width: getScreenBounds().width * 0.9,
                           height: getScreenBounds().height * 0.8,
                           alignment: .center)
                    .lineSpacing(10)
                    .border(Color.primary)
                    .multilineTextAlignment(.leading)
                    .font(.footnote)
            }
        }
        .toolbar {
            Button {
                isShowInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
        }
    }
}

struct CodeSnippetTextEditor_Previews: PreviewProvider {
    @State static var binding = ""
    static var previews: some View {
        CodeSnippetTextEditor(textEditor: $binding)
    }
}
