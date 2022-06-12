//
//  getScreenBounds.swift
//  SwiftUIFirebaseChat
//
//  Created by Tolga Kağan Aysu on 1.05.2022.
//
import SwiftUI

//Used to adjust the frames to the screen boundaries
extension View {
    func getScreenBounds() -> CGRect{
        return UIScreen.main.bounds
    }
}
