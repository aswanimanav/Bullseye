//
//  ContentView.swift
//  Bullseye
//
//  Created by Manav Aswani on 02/02/20.
//  Copyright © 2020 Manav Aswani. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var currentRound = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    struct Shadow: ViewModifier {
         func body(content: Content) -> some View {
             return content
                 .shadow(color: Color.black, radius: 5, x: 2, y: 2)
         }
     }
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.white)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
        
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    var body: some View {
            VStack {
                Spacer()
                // Target row
                HStack {
                    Text("Put the Bullseye as close as you can to:").modifier(LabelStyle())
                    Text("\(target)").modifier(ValueStyle())
                }
                Spacer()
                //Slider row
                HStack {
                    Text("1").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100).accentColor(Color.green)
                    Text("100").modifier(LabelStyle())
                }
                Spacer()
                //Button row
                Button(action: {
                    self.alertIsVisible = true
                }) {
                    Text(/*@START_MENU_TOKEN@*/"Hit Me!"/*@END_MENU_TOKEN@*/).modifier(ButtonLargeTextStyle())
                }
                .alert(isPresented: $alertIsVisible) { () ->
                    Alert in
                    return Alert(title: Text(alertTitle()),
                         message: Text("The slider's value is \(sliderValueRounded()).\n"
                            + "You scored \(pointsForCurrentRound()) points this round."
                    ), dismissButton: .default(Text("Awesome")) {
                            self.score = self.score + self.pointsForCurrentRound()
                            self.target = Int.random(in: 1...100)
                            self.currentRound += 1
                        })
                }
                .background(Image("Button")).modifier(Shadow())
                Spacer()
                //Score row
                HStack {
                    Button(action: {
                        self.startOver()
                    }) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")).modifier(Shadow())
                    Spacer()
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    Spacer()
                    Text("Round:").modifier(LabelStyle())
                    Text("\(currentRound)").modifier(ValueStyle())
                    Spacer()
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("info").modifier(ButtonSmallTextStyle())
                        }
                   }
                    .background(Image("Button")).modifier(Shadow())
                }
                .padding(.bottom, 20)
            }
            .background(Image("Background"), alignment: .center)
            .accentColor(midnightBlue)
            .navigationBarTitle("Bullseye")
    }
    
    func sliderValueRounded() -> Int {
        Int(sliderValue.rounded())
    }
    
    func amountOff() -> Int {
        abs(sliderValueRounded() - target)
    }
    
    func pointsForCurrentRound() -> Int {
        var points = 0
        if amountOff() == 0 {
            points = 200 - amountOff()
        } else if amountOff() == 1 {
            points = 150 - amountOff()
        } else {
            points = 100 - amountOff()
        }
        return points
    }
    
    func alertTitle() -> String {
        let difference = amountOff()
        let title: String
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    func startOver() {
        sliderValue = 50.0
        self.target = Int.random(in: 1...100)
        currentRound = 1
        score = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
