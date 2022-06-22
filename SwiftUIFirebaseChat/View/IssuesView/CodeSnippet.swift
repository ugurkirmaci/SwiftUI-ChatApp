//
//  CodeSnippet.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.06.2022.
//

import SwiftUI
struct CodeSnippet: View {
    let codeSnippetString: String
    
    var body: some View {
        ScrollView([.vertical,.horizontal],showsIndicators: true) {
            Text(codeSnippetString)
        }.frame(width: .none,
                height: .none,
                alignment: .topLeading )
        .padding(.top)
    }
}

struct CodeSnippet_Previews: PreviewProvider {
    static var previews: some View {
        CodeSnippet(codeSnippetString: "Test")
    }
}
