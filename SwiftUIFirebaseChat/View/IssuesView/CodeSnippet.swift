//
//  CodeSnippet.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.06.2022.
//

import SwiftUI
struct CodeSnippet: View {
    let codeSnippetString: String
    @Binding var answerColor: Bool
    
    var body: some View {
        ScrollView([.vertical,.horizontal],showsIndicators: true) {
            Text(codeSnippetString)
                .padding()
                .background(answerColor ? Color.green : Color.red)
                .cornerRadius(30)
                .foregroundColor(.white)
                
                
        }.frame(width: .none,
                height: .none,
                alignment: .topLeading )
        
        
        .padding(.top)
    }
}

struct CodeSnippet_Previews: PreviewProvider {
    @State static var answerColor = true
    static var previews: some View {
        CodeSnippet(codeSnippetString: "Test", answerColor: $answerColor)
    }
}
