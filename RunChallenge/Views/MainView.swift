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
        
        // complete view
        ZStack {
            Color.black
                .ignoresSafeArea()
            // complete container
            VStack {
                // header
                VStack(alignment: .leading) {
                    HStack {
                        Text("Your Challenge")
                            .font(.system(.largeTitle, design: .default))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Text("\(dates.date.monthAsString()) \(String(dates.date.get(.year)))")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .padding([.top, .leading, .trailing], 20)
                Spacer()
                // content block
                VStack {
                    Spacer()
                    // circles
                    HStack {
                        ZStack {
                            ZStack {
                                // full circle
                                Circle()
                                    .stroke(lineWidth: 35.0)
                                    .opacity(0.3)
                                    .foregroundColor(Color.blue)
                                    .frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.width - 120)
                                    .padding()
                                // progress circle
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(challengeProgress, 1.0)))
                                    .stroke(
                                        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                        style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0).delay(1))
                                    .frame(width: UIScreen.main.bounds.width - 120, height: UIScreen.main.bounds.width - 120)
                                    .padding()
                            }
                            // inside circles
                            VStack {
                                Text("\(String(format: "%.2f", self.sumOfRunsMonth)) KM")
                                    .font(.system(size: 28.0, weight: .black, design: .default))
                                    .foregroundColor(.white)
                                .padding(20)
                                Text("\(String(format: "%.0f", self.distanceChallenge)) KM")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20.0, weight: .regular, design: .default))
                            }
                        }
                    }
                    Spacer()
                    // table
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
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(Color("mDarkColor"))
                    .cornerRadius(15)
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                // footer
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
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 8 Plus")
            .environment(\.locale, .init(identifier: "en"))    }
}
