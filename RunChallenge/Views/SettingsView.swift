//
//  File.swift
//  RunChallenge
//
//  Created by Moritz Haist on 14.03.21.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    
    @State var currentChallenge: Double
    @Binding var isPresented: Bool
    
    func sliderValueChanged() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    func getCircleWidth() -> CGFloat{
        return ( CGFloat(currentChallenge) / 10)
    }
    
    func updateChallenge() {
        let newChallenge = currentChallenge
        UserDefaults(suiteName: "group.com.bildstrich.net.RunChallengeApp")!.set(newChallenge, forKey: "distanceChallenge")
        WidgetCenter.shared.reloadAllTimelines()
        isPresented = false
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                // header
                VStack {
                    ZStack(alignment: .topLeading) {
                        Image("settingsViewHeader16-9")
                            .resizable()
                            .scaledToFit()
                            .overlay(ImageOverlay().opacity(0.7))
                        // headline / closebutton / text
                        VStack {
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
                            Text("How many kilometers do you want to run this month?")
                                .font(.body)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(20)
                        }
                    }
                }
                .padding(.bottom, 20)
                // cirle
                VStack {
                    ZStack(alignment: .center) {
                        Circle()
                            .stroke(
                                LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                style: StrokeStyle(lineWidth: self.getCircleWidth(), lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: (currentChallenge) * 2))
                            .foregroundColor(Color.white)
                        VStack(alignment: .center) {
                            Text("\(String(format: "%.2f", currentChallenge))")
                                .font(.system(size: 30.0, weight: .black, design: .default))
                                .foregroundColor(.white)
                                .padding(20)
                            Text("KM")
                                .foregroundColor(.gray)
                                .font(.system(size: 20.0, weight: .regular, design: .default))
                            
                        }
                    }
                    .foregroundColor(.white)
                }
                // slider & button
                VStack {
                    // distance challenge
                    ZStack {
                        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading)
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
                                    .stroke(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading), lineWidth: 3)
                            )
                    }
                    Spacer()
                }
                
            }
        }
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
        Group {
            SettingsView(currentChallenge: 150.0, isPresented: .constant(true))
                .environment(\.locale, .init(identifier: "de"))
            
        }
    }
}
