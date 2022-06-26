//
//  ChatLogView.swift
//  SwiftUIFirebaseChat


import SwiftUI
import Firebase
import FirebaseFirestore

//Firebase for ChatLog
class ChatLogViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    //MARK: - Initialiser
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    //MARK: - Public Methods
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirbaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirbaseConstants.timestamp).addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                //Yazilan mesajlarin chatlogda gozukmesi icin;
                querySnapshot?.documentChanges.forEach({ change in
                    //eger eklenen mesajlar esitse diger degisen mesajlara yazili olan mesajlari bas.
                    // Bu eklenen mesajlarin ekrana 2 kere basmamasini sagliyoruz.
                    if change.type == .added {
                        do {
                            if let cm = try
                                change.document.data(as: ChatMessage.self) {
                                self.chatMessages.append(cm)
                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                })
                
                DispatchQueue.main.async {//Artik kisinin ustune tikladigimizda yazidigi yeni mesaji oto gorucez.
                    self.count += 1//mesaj yolladimizda scrol nerde olursa olsun yazdigimiz mesaji en basta gosterir.
                }
            }
    }
    
    //MARK: - Public Methods
    
    //Mesaj gondermek icin func
    func handleSend() {
        print(chatText)
        //Firebase users data fromId
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection(FirbaseConstants.messages)
            .document(fromId).collection(toId).document()
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        try? document.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            // + New Message kismini duzenlemek icin
            self.persistRecentMessage()
            
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
             .document(toId).collection(fromId).document()
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    //MARK: - Private Methods
    
    //persistRecentMessage func.
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirbaseConstants.recentMessages)
            .document(uid)
            .collection(FirbaseConstants.messages)
            .document(toId)
        
        let data = [
            FirbaseConstants.timestamp: Timestamp(),
            FirbaseConstants.text: self.chatText,
            FirbaseConstants.fromId: uid,
            FirbaseConstants.toId: toId,
            FirbaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirbaseConstants.email: chatUser.email
        ] as [String : Any]
        
        //you'll need to save another very similar dictionary for the recipient of this message...how?
        
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
//        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        
//        let recipientRecentMessageDictionary = [
//            FirbaseConstants.timestamp: Timestamp(),
//            FirbaseConstants.text: self.chatText,
//            FirbaseConstants.fromId: uid,
//            FirbaseConstants.toId: toId,
//            FirbaseConstants.profileImageUrl: currentUser.profileImageUrl,
//            FirbaseConstants.email: currentUser.email
//        ] as [String: Any]
//
//        FirebaseManager.shared.firestore
//            .collection(FirbaseConstants.recentMessages)
//            .document(toId)
//            .collection(FirbaseConstants.messages)
//            .document(currentUser.uid)
//            .setData(recipientRecentMessageDictionary) { error in
//                if let error = error {
//                    print("Failed to save recipent recent message: \(error)")
//                    return
//                }
//            }
    }
    
    //MARK: - Properties
    
    //Yazilan mesajlarda send butonuna bastigimizda  scroll otomatik olarak en basa eklemesi icin
    @Published var count = 0
}


//ChatLog func icine girdigimizde back butonu saginda gmail adrsi konustugumuz kisinin mail bilgisini gosterocez.
struct ChatLogView: View {
    
//    let chatUser: ChatUser?
//
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.vm = .init(chatUser: chatUser)
//    }
    
    //MARK: - Properties
    
    //@ObservedObject Sayfanız içerisinde yaptigimiz değişimleri diğer sayfalara taşıyabilir.Taşınan sayfada yapılan değişiklikler bir önceki sayfa üzerindede update edilmiş olur.
    @ObservedObject var vm: ChatLogViewModel
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)//back butonunun yanina mail adresleri
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    //MARK: - Private Methods
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(vm.chatMessages) { message in
                            MessageView(message: message)
                        }
                        HStack { Spacer() }
                        .id(Self.emptyScrollToString)
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
                
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            //Alt tab kismini ayarlamak icin
            .safeAreaInset(edge: .bottom) {
                chatBottomBar
                    .background(Color(.systemBackground).ignoresSafeArea())
            }
            
        } 
        
    }
    
    //MARK: - Private Methods
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button {
                if vm.chatText != "" {
                    vm.handleSend()
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.right.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    //MARK: - Properties
    
    let message: ChatMessage
    
    //MARK: - Body
    
    var body: some View {
        // Karsi tarafin yazdigi mesaj gorunum style.
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

//MARK: - Private Methods

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Write Message")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

//MARK: - Previews

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["uid": "pgyWf76gIQZsDhMQpBPAOrzHHh12","email": "waterflow@gmail.com"]))
//        }
        MainMessageView()
    }
}
