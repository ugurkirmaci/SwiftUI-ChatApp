//
//  FirebaseManager.swift
//  SwiftUIFirebaseChat


import Foundation
import Firebase
import FirebaseFirestore


//Firebase xcode similoturu uzerinde crash yememesi icin
class FirebaseManager: NSObject {
    
    //MARK: - Properties
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    //MARK: - Initialiser
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
