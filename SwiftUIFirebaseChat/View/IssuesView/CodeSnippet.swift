//
//  CodeSnippet.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.06.2022.
//

import SwiftUI
import MarkdownUI
struct CodeSnippet: View {
    let codeSnippetString: String
  
   
    var body: some View {
        ScrollView([.vertical,.horizontal]) {
            Markdown(
                
                   codeSnippetString
            )
                                .markdownStyle(
                    MarkdownStyle(
                        font: .system(.body, design: .serif ),
                        foregroundColor: .indigo,
                        measurements: .init(
                            codeFontScale: 0.8,
                            headingSpacing: 0.05
                        )
                    )
                )
            
            
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
