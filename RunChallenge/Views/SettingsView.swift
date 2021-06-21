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
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                // header
                VStack {
                    ZStack(alignment: .topLeading) {
                        Image("settingsHeaderRunning")
                            .resizable()
                            .scaledToFill()
                            .overlay(ImageOverlay().opacity(0.7))
                        // headline / button
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Set your")
                                    .font(.system(.largeTitle, design: .default))
                                    .fontWeight(.black)
                                Text("Challenge")
                                    .font(.system(.largeTitle, design: .default))
                                    .fontWeight(.black)
                            }
                            .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                isPresented = false
                            }, label: {
                                Image(systemName: "chevron.down.circle.fill")
                                    .foregroundColor(Color.white)
                                    .font(.largeTitle)
                            })
                        }
                        .padding(20)
                        // distance challenge
                        ZStack(alignment: .bottom){
                            Color.clear
                            ZStack(alignment: .center) {
                                Circle()
                                    .stroke(
                                        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5354012868490564, saturation: 0.45592020793133475, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5639713241393308, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                        style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color.white)
                                    .frame(width: 140, height: 140)
                                    .padding(30)
                                VStack {
                                    Text("\(String(format: "%.0f", currentChallenge))")
                                        .font(.system(size: 30.0, design: .default))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 1.0)
                                    Text("KM")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15.0, weight: .regular, design: .default))
                                }
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                
                // slider & button
                VStack {
                    
                    VStack {
                        Spacer()
                        Text("How many kilometers do you want to run this month?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal, 20)
                    }
                    ZStack(alignment: .center) {
                        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5354012868490564, saturation: 0.45592020793133475, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5639713241393308, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading)
                            .mask(Slider(value: $currentChallenge, in: 0...300, step: 1))
                        Slider(value: Binding(
                            get: {
                                self.currentChallenge
                            },
                            set: {(newValue) in
                                self.currentChallenge = newValue
                                self.sliderValueChanged()
                            }
                        ), in: 1...300, step: 1)
                        .accentColor(.clear)
                    }
                    
                    .foregroundColor(.white)
                    .padding(20)
                    
                    Button(action: {
                        self.updateChallenge()
                    }) {
                        Text("Set challenge")
                            .fontWeight(.medium)
                            .font(.body)
                            .padding()
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5354012868490564, saturation: 0.45592020793133475, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5639713241393308, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading), lineWidth: 2)
                            )
                    }
                }
                
            }
        }
    }
    func updateChallenge() {
        let newChallenge = currentChallenge
        UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(newChallenge, forKey: "distanceChallenge")
        isPresented = false
    }
    
}

struct ImageOverlay: View {
    var body: some View {
        ZStack {
            Text(" ")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(currentChallenge: 150.0, isPresented: .constant(true))
    }
}
