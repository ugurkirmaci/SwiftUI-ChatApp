//
//  IssueSortPicker.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 27.06.2022.
//

import SwiftUI

struct IssueSortPicker: View {
    @Binding var selection: IssueSortBy
    var body: some View {
        Picker("Sort By", selection: $selection) {
            ForEach(IssueSortBy.allCases) {
                Text($0.rawValue).tag($0)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct IssueSortPicker_Previews: PreviewProvider {
    @State static var sortby = IssueSortBy.Date
    static var previews: some View {
        IssueSortPicker(selection: $sortby)
    }
}
