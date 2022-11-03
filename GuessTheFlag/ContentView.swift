//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adam Wilkanowski on 02/11/2022.
//

import SwiftUI

struct ContentView: View {
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    @State private var resetGame = false
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 2
        } else {
            scoreTitle = "Wrong, that's flag of \(countries[number]) "
            score -= 1
        }
        questionCount += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        finalAlert()
    }
    
    func finalAlert(){
        if questionCount == 8{
           resetGame = true
        }
    }
    func reset(){
        score = 0
        questionCount = 0
        resetGame = false
        countries = Self.allCountries
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack{
                
                Spacer()
                
                Text("Guess the Flag")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                VStack(spacing:15) {
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundColor(.secondary)
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
            
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .alert("The game has finished.", isPresented: $resetGame) {
                Button("Reset", action: reset)
            } message: {
                Text("Your final score is \(score)")
            }
        }}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
