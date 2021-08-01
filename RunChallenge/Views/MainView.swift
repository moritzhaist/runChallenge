//
//  ContentView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI
import Foundation

struct MainView: View {
    
    // updated in HealthKitQuery Class
    @AppStorage("sumOfRunsMonth", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var sumOfRunsMonth: Double = 0.00
    @AppStorage("sumOfRunsYear", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var sumOfRunsYear: Double = 0.00
    // updated in SettingsView
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var distanceChallenge: Double = 50.00
    
    @State private var showingSettings = false
    @State private var showingInfo = false
    
    let dates = Dates()
    
    // view
    var body: some View {
        let challengeProgress = Float(sumOfRunsMonth) / Float(distanceChallenge)
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                
                // header
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Your current Challenge")
                            .font(.system(.largeTitle, design: .default))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Text("\(dates.date.monthAsString()) \(String(dates.date.get(.year)))")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    
                }
                .padding(20)
                
                // circles
                HStack {
                    ZStack {
                        ZStack {
                            // full circle
                            Circle()
                                .stroke(lineWidth: 35.0)
                                .opacity(0.3)
                                .foregroundColor(Color.blue)
                            // progress circle
                            Circle()
                                .trim(from: 0.0, to: CGFloat(min(challengeProgress, 1.0)))
                                .stroke(
                                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                    style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0).delay(1))
                        }
                        .padding(20)
                        // inside circles
                        VStack {
                            Text("\(String(format: "%.2f", self.sumOfRunsMonth)) KM")
                                .font(.system(size: 30.0, weight: .black, design: .default))
                                .foregroundColor(.white)
                                .padding(30)
                            Text("\(String(format: "%.0f", self.distanceChallenge)) KM")
                                .foregroundColor(.gray)
                                .font(.system(size: 20.0, weight: .regular, design: .default))
                        }
                    }
                    .padding(20)
                }
                
                // table
                VStack {
                    VStack {
                        HStack(alignment: .center){
                            Text("Challenge completed")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.1f", (challengeProgress * 100))) %")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        Divider().background(Color.gray)
                        HStack(alignment: .center){
                            Text("Kilometers left")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.2f", (self.distanceChallenge - self.sumOfRunsMonth))) KM")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        Divider().background(Color.gray)
                        HStack(alignment: .center){
                            Text("Days left in month")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(dates.getRemainingDays())")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        Divider().background(Color.gray)
                        HStack(alignment: .center){
                            Text("Total running distance in \(String(dates.date.get(.year)))")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.2f", self.sumOfRunsYear)) KM")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color("mDarkColor"))
                }
                .cornerRadius(15)
                .padding(20)
                
                // buttons
                VStack {
                    HStack {
                        Button(action: {showingInfo = true}) {
                            Image(systemName: "info.circle")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                        }
                        .sheet(isPresented: $showingInfo, content: {
                            InfoView(isPresented: $showingInfo)
                        })
                        Spacer()
                        Button(action: {showingSettings = true}) {
                            Image(systemName: "gear")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                        }
                        .sheet(isPresented: $showingSettings, content: {
                            SettingsView(currentChallenge: self.distanceChallenge, isPresented: $showingSettings)
                        })
                    }
                    
                    .padding([.top, .leading, .trailing], 20.0)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 12 Pro Max")
            .environment(\.locale, .init(identifier: ""))    }
}




