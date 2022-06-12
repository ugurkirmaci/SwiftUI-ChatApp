//  CodeSnippetTextEditor.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 30.05.2022.
//
import SwiftUI

struct CodeSnippetTextEditor: View {
    @Binding var textEditor: String
    var body: some View {

        TextEditor(text: $textEditor)
            .frame(width: getScreenBounds().width * 0.9,
                   height: getScreenBounds().height * 0.6,
                   alignment: .center)
            .lineSpacing(10)
            .border(Color.primary)
            .multilineTextAlignment(.leading)
            .font(.footnote)

    }
}

struct CodeSnippetTextEditor_Previews: PreviewProvider {
    @State static var binding = ""
    static var previews: some View {
        CodeSnippetTextEditor(textEditor: $binding)
    }
}
