//
//  isHiddenExtension.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 13.05.2022.
//

import Foundation
import SwiftUI

//Hide view by bool value
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        
        if hidden {
            self.hidden()
        }
        else{
            self
        }
    }
}
