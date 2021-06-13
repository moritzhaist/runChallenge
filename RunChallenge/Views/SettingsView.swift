//
//  File.swift
//  RunChallenge
//
//  Created by Moritz Haist on 14.03.21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var currentChallenge: Double
    @Binding var isPresented: Bool
    
    func sliderValueChanged() {
        let selectionFeedback = UISelectionFeedbackGenerator()
                       selectionFeedback.selectionChanged()
    }

    var body: some View {
    
            VStack() {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Set your")
                            .font(.system(.largeTitle, design: .default))
                            .fontWeight(.black)
                        Text("Challenge")
                            .font(.system(.largeTitle, design: .default))
                            .fontWeight(.black)
                    }
                    Spacer()
                    
                    Button(action: {
                            isPresented = false
                        }, label: {
                            Image(systemName: "chevron.down.circle.fill")
                                .foregroundColor(Color.gray)
                                .font(.largeTitle)
                        })
                
                }
                .padding(20)
                
                VStack{
                    Spacer()
                    Text("\(String(format: "%.0f", currentChallenge)) KM")
                        .font(.system(size: 30.0, weight: .black, design: .default))
                    Spacer()
                    Text("Set the distance you want to run this month")
                    
                }
                
                HStack {
                    Text(" 0\nkm")
                        .padding()
                        .font(.system(.caption))
                    ZStack {
                          LinearGradient(
                              gradient: Gradient(colors: [.blue, .blue]),
                              startPoint: .leading,
                              endPoint: .trailing
                          )
                          .mask(Slider(value: $currentChallenge, in: 0...300, step: 1))
                          Slider(value: Binding(
                            get: {
                                self.currentChallenge
                            },
                            set: {(newValue) in
                                  self.currentChallenge = newValue
                                  self.sliderValueChanged()
                            }
                        ), in: 0...300, step: 1)
                              .accentColor(.clear)
                    }
                    Text("300\n km")
                        .padding()
                        .font(.system(.caption))
                }
        
         
                
                Button("Accept Challenge", action: {self.updateChallenge()} )
                    .padding()
                    .background(Color/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .border(Color.blue, width: 5)
                    .cornerRadius(40)
                Spacer()
        }
    }
    func updateChallenge() {
        let newChallenge = currentChallenge
        UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(newChallenge, forKey: "distanceChallenge")
        isPresented = false
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(currentChallenge: 150.0, isPresented: .constant(true))
    }
}
