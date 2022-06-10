//
//  MainMessageView.swift
//  SwiftUIFirebaseChat


import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift


//Login oldugunda gozukmesi icin
class MainMessageViewModel: ObservableObject {
    
    //MARK: - Properties
    //Error Message Published
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    
    //MARK: - Initialiser
    
    init() {
        
        DispatchQueue.main.async {
            //Login butonuna bastiginda MainMessageView'un icine girmek icin.
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    //MARK: - Properties
    
    @Published var recentMessages = [RecentMessage]()
    
    //MARK: - Private Methods
    
    private var  firestoreListener: ListenerRegistration?
    
    //MARK: - Public Method
    //recent func.
     func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
         firestoreListener?.remove()
         self.recentMessages.removeAll()
         
         
         firestoreListener = FirebaseManager.shared.firestore
            .collection(FirbaseConstants.recentMessages)
            .document(uid)
            .collection(FirbaseConstants.messages)
            .order(by: FirbaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                //Son yazilan mesajlarin profil resiminin altinda yazmasi
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    //FirebaseFirestoreSwift kutuphanesiyle kullanilan newMessage list.
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    //MARK: - Public Methods
    
     func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase  uid"
            return
        }
        
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
 
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
                //ChatUSer
                self.chatUser = .init(data: data)
//                FirebaseManager.shared.currentUser = self.chatUser
        }
    }
    
    //MARK: - Public Methods
    
    //SignOut func
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()// login olduktan sonra resim alani bos gelicek.
    }
    
}

struct MainMessageView: View {
    
    //MARK: - Properties
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    //MainMassageViewModel'i burdan cekiyoruz.
    @ObservedObject private var vm = MainMessageViewModel()
    
    //MARK: - Private Methods
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            
            VStack {
                // custom nav bar
                customNavBar
                messageView
                //Users secili oldugunda
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                }
            }
            .overlay( // + New Message
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    //MARK: - Private Methods
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            //SDWebImage kutuphanesinde
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            
            VStack(alignment: .leading, spacing: 4) {
                //Login olduktan sonra
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {//LoginButton
                shouldShowLogOutOptions.toggle()
            } label: {
                //Login iconu
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {//ActionSheet
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
                self.vm.fetchRecentMessages()
            })
        }
    }
    
    //MARK: - Private Methods

    private var messageView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ?
                        recentMessage.toId : recentMessage.fromId
                        self.chatUser = .init(data:
                                                [FirbaseConstants.email: recentMessage.email,FirbaseConstants.profileImageUrl: recentMessage.profileImageUrl,
                                                 FirbaseConstants.uid: uid])
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                    }
   
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    //MARK: - Properties
    
    //+NewMessage butona tiklandiginda list gelecek
    @State var shouldShowNewMessageScreen = false
    
    //MARK: - Private Methods
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil) {
            CreateNewMessageView(didSelectNewUser: { user in
                print(user.email)//Artik kullanicilar secili oldugunda icine giricek.
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
            })
        }
    }
    
    @State var chatUser: ChatUser?
}

//MARK: - Previews

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
            .preferredColorScheme(.dark)
        
        MainMessageView()
    }
}
