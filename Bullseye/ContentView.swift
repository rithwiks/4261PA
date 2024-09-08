//
//  ContentView.swift
//  Bullseye
//
//  Created by Rithwik Seth on 8/25/24.
//

import SwiftUI
import RealmSwift


struct ContentView: View {
    
    @State var alertIsVisible = false
    @State private var alertType = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in:1...100)
    @State var score = 0
    @State var currRound = 1
    let app = RealmSwift.App(id: "application-0-lhowrbx")
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAuthenticated = false
    @State private var isRegistering = false
    @State private var errorMessage: String?
    @State var scoreToBeat = 0
    
    
    
    var body: some View {
        VStack {
            if self.isAuthenticated {
                VStack {
                    VStack {
                        //Text Row
                        Spacer()
                        HStack {
                            Text("Put the bullseye as close as you can to:")
                            Text("\(self.target)")
                        }
                        Spacer()
                        
                        //Slider Row
                        HStack{
                            Text("1")
                            Slider(value: self.$sliderValue, in: 1...100)
                            Text("100")
                        }
                        Spacer()
                        //Hit Me Row
                        Button("Hit me") {
                            print("Button pressed")
                            alertType = false
                            self.alertIsVisible = true
                        }
                        .alert(isPresented: $alertIsVisible) {
                            if currRound < 5 {
                                
                                return Alert(title: Text(self.alertTitle()), message: Text("The slider's value is \(Int(round(self.sliderValue)))\n You scored \(self.pointsForGuess()) points this round."
                                                                                          ), dismissButton: .default(Text("Awesome")) {
                                    self.score = self.score + self.pointsForGuess()
                                    self.currRound = self.currRound + 1
                                    self.target = Int.random(in:1...100)
                                })
                            } else {
                                return Alert(title: Text("Leaderboard Submission"), message: Text("The slider's value is \(Int(round(self.sliderValue)))\n You scored \(self.pointsForGuess()) points this round. \nYour score for 5 rounds is \(self.score+self.pointsForGuess())!\n The game will restart!"), dismissButton: .default(Text("Awesome")) {
                                    self.scoreToBeat = max(self.score+self.pointsForGuess(), self.scoreToBeat)
                                    self.score = 0
                                    self.currRound = 1
                                    self.target = Int.random(in:1...100)
                                })
                            }
                            
                        }
                        
                        Spacer()
                        // Score Row
                        HStack {
                            Button("Start over") {
                                score = 0
                                currRound = 1
                                target = Int.random(in:1...100)
                            }
                            Spacer()
                            Text("Score: ")
                            Text("\(score)")
                            Spacer()
                            Text("Round: ")
                            Text("\(currRound)")
                            Spacer()
                            Text("Score to Beat: ")
                            Text("\(scoreToBeat)")
                            Spacer()
                            Button("Log out", action:logOut)
                        }.padding(.bottom, 20)
                    }
                }
            } else if isRegistering {
                TextField("Email", text: $email)
                                        .autocapitalization(.none)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Register", action:registerSync)
                    .padding()
                
                Button("Cancel", action: {
                    isRegistering = false
                })
                .padding()
            } else {
                TextField("Email", text: $email)
                                        .autocapitalization(.none)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Log In", action: logIn)
                    .padding()
                
                Button("Create Account", action: {
                    isRegistering = true
                })
                .padding()
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
        }
    }
    private func registerSync() {
        Task {
            do {
                try await register()
            } catch {
                print(error)
            }
        }
    }
    private func register() async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        let credentials = Credentials.emailPassword(email: email, password: password)
       
        do {
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            logIn()
        } catch {
            print("Failed to register: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
   }
    
    private func logIn() {
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        app.login(credentials: credentials) { result in
            switch result {
            case .success(let user):
                print("Successfully logged in as user: \(user)")
                self.scoreToBeat = 0
                self.score = 0
                self.currRound = 1
                self.target = Int.random(in:1...100)
                isAuthenticated = true
            case .failure(let error):
                print("Failed to log in: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    private func logOut() {
        guard let user = app.currentUser else { return }
        
        user.logOut { error in
            if let error = error {
                print("Failed to log out: \(error.localizedDescription)")
                return
            }
            print("Logged out successfully")
            isAuthenticated = false
        }
    }
    func pointsForGuess() -> Int {
        let diff = 100 - abs(Int(self.sliderValue.rounded()) - self.target)
        if diff == 100 {
            return 200
        } else if diff == 99 {
            return 149
        } else {
            return diff
        }
                
    }
    func alertTitle() -> String {
        let diff = abs(Int(self.sliderValue.rounded()) - self.target)
        if diff == 0 {
            return "Perfect"
        } else if diff < 5 {
            return "Very close"
        } else if diff <= 10 {
            return "Not bad"
        } else {
            return "Try harder"
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
