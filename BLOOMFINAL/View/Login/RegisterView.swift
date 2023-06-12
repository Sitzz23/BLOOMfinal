//
//  RegisterView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import iPhoneNumberField

struct RegisterView: View{
    //user details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var phoneNum: String = ""
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss
    @State var isLoading: Bool = false
    
    //MARK: user defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        ZStack {
            RegisterBackgroundView()
            VStack(spacing: 10){
                Text ("BLOOM")
                    .font (.largeTitle.bold ())
                    .hAlign( .leading)
                
                Text ("Create Account")
                    .font (.title3)
                    .hAlign(.leading)
                
                VStack(spacing: 12){
                    TextField("Username", text: $userName)
                        .textContentType(.name)
                        .border(1, .black)
                        .padding(.top, 25)
                    
                    iPhoneNumberField("Mobile number", text: $phoneNum)
                        .border(1, .black)
                    
                    TextField("Email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .black)
                    
                    SecureField( "Password", text: $password)
                        .textContentType (.password )
                        .border(1, .black)
                
                    Button(action: registerUser){
                        Text("Sign up")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                    }
                    .padding(.top)
                    .disableWithOpacity(userName == "" || password == "" || emailID == "" || phoneNum == "" )
                    
                }
                
                HStack{
                Text ("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button ("Login Now"){
                        dismiss()
                    }
                    .fontWeight (.bold)
                    .foregroundColor (.black)
                }
                .font(.callout)
                .vAlign(.bottom)
            }
            .vAlign(.top)
            .padding(15)
            .alert(errorMessage, isPresented: $showError, actions: {})
            .overlay(content: {
                LoadingView(show: $isLoading)
        })
        }
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                let user = User(userName: userName, userEmail: emailID, userUID: userUID, userNumber: phoneNum)
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil{
                        print("saved successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        logStatus = true
                    }
                })
            }catch{
                await setError(error)
            }
        }
    }
    func setError(_ error:Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct RegisterBackgroundView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Image("Image 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .offset(x: 150,y: -320)
            
            Image("Image 29")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 300)
                .rotationEffect(Angle(degrees: -25))
                .offset(x: -190, y: 410)
                
          
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("background"))
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
       RegisterView()
    }
}
