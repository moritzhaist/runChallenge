//
//  ContentView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI

struct ContentView: View {
    
    // updated in HealthKitQuery Class
    @AppStorage("sumOfRuns", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var sumOfRuns: Double = 0.00
    
    // updated in SettingsView
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var distanceChallenge: Double = 50.00
        
    @State private var showingSettings = false
    
    func getChallengeProgress () -> Float {
        return Float(sumOfRuns) / Float(distanceChallenge)
    }
    
    
    var body: some View {
        
        ZStack {
            Color.black
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 35.0)
                            .opacity(0.3)
                            .foregroundColor(Color.blue)
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(self.getChallengeProgress(), 1.0)))
                            .stroke(
                                style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: 270.0))
                            .foregroundColor(Color(hue: 0.509, saturation: 1.0, brightness: 1.0))
                            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0).delay(1))
                    }
                    .frame(width: 250.0, height: 250.0)
                    .padding(.top, 50)
                    
                    VStack {
                        Text("\(String(format: "%.2f", self.sumOfRuns)) KM")
                            .foregroundColor(.white)
                            .font(.system(size: 30.0, weight: .black, design: .default))
                            .padding(30)
                        Text("\(String(format: "%.0f", self.distanceChallenge)) KM")
                            .foregroundColor(.gray)
                            .font(.system(size: 20.0, weight: .regular, design: .default))
                    }
                }
                
                HStack {
                    Button(action: {showingSettings = true}) {
                        Image(systemName: "gear")
                        .font(.title)
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50, alignment: .trailing)
                        .padding(.top, 25)
                        }
                    .sheet(isPresented: $showingSettings, content: {
                        SettingsView(currentChallenge: self.distanceChallenge, isPresented: $showingSettings)
                    })
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
