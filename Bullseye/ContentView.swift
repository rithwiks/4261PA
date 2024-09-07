//
//  ContentView.swift
//  Bullseye
//
//  Created by Rithwik Seth on 8/25/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in:1...100)
    @State var score = 0
    @State var currRound = 1
    
    var body: some View {
        VStack {
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
                        self.alertIsVisible = true
                    }
                    .alert(isPresented: $alertIsVisible) {
                        () -> Alert in
                        return Alert(title: Text(self.alertTitle()), message: Text("My slider's value is \(Int(round(self.sliderValue)))\n You scored \(self.pointsForGuess()) points this round."
                                                                              ), dismissButton: .default(Text("Awesome")) {
                            self.score = self.score + self.pointsForGuess()
                            self.target = Int.random(in:1...100)
                            self.currRound = self.currRound + 1
                        })
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
                        Button("Info") {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        }
                    }.padding(.bottom, 20)
                }
            }
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
