//
//  CreateNewMessageView.swift
//  SwiftUIFirebaseChat
//
//  Created by UğurKırmacı on 29.12.2021.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var users = [ChatUser]()//[ChatUser]? seklinde de kullanilir.
    @Published var errorMessage = ""
    
    //MARK: - Initialiser
    
    init() {
        fetchAllUsers()
    }
    
    //MARK: - Private Methods
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = ChatUser(data: data)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(.init(data: data))
                }
            })
        }
    }
}

struct CreateNewMessageView: View {
    
    //MARK: - Properties
    
    //Kullanicilar secildiginde
    let didSelectNewUser: (ChatUser) -> ()//callback func.
    
    //Cencel butonu icin
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                //NewMessage butona bastiginda kullanicilar geliyor.
                ForEach(vm.users) { user in
                    //NewMessage'deki kisilere tikladigimizda
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .placeholder(content: {
                                    ProgressView()
                                })
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 2)
                                )
                            
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()//Alt cizgi
                        .padding(.vertical, 8)

                }
            }.navigationTitle("New Message")
                .navigationBarTitleDisplayMode(.inline)
            //navigationBarItems icin swiftui'da kullanmak icin .toolbar(content:) eklememiz gerekiyor.
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cencel")
                        }
                    }
                }
        }
    }
}

//MARK: - Previews

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        CreateNewMessageView()
        MainMessageView()
    }
}
