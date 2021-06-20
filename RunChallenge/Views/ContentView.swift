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
    
    
    let date = Date()
    let cal = Calendar(identifier: .gregorian)
    
    
    func getChallengeProgress () -> Float {
        return Float(sumOfRuns) / Float(distanceChallenge)
    }
    
    func getRemainingDays() -> Int {
        let monthRange = cal.range(of: .day, in: .month, for: date)!
        let daysInMonth = monthRange.count
        return daysInMonth - (date.get(.day))
    }
    
    func getYear() -> Int {
        return (date.get(.year))
    }
    
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack() {
                VStack(alignment: .leading) {
                    // header
                    HStack(alignment: .top) {
                        Text("Your Challenge")
                            .font(.system(.largeTitle, design: .default))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Text("\(date.monthAsString()) \(String(date.get(.year)))")
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
                                .trim(from: 0.0, to: CGFloat(min(self.getChallengeProgress(), 1.0)))
                                .stroke(
                                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5354012868490564, saturation: 0.45592020793133475, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5639713241393308, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                    style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270.0))
                                .foregroundColor(Color(hue: 0.509, saturation: 1.0, brightness: 1.0))
                                .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0).delay(1))
                        }
                        .padding(20)
                        // inside circles
                        VStack {
                            Text("\(String(format: "%.2f", self.sumOfRuns)) KM")
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
                        HStack{
                            Text("Challenge completed")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.1f", (self.getChallengeProgress() * 100))) %")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Divider().background(Color.gray)
                        HStack{
                            Text("Kilometers left")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.2f", (self.distanceChallenge - self.sumOfRuns))) km")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Divider().background(Color.gray)
                        HStack{
                            Text("Days left in Month")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(self.getRemainingDays()) days")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Divider().background(Color.gray)
                        HStack{
                            Text("Total running distance in \(String(date.get(.year)))")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("xxx km")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(20)
                    .background(Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255))
                }
                .cornerRadius(15)
                .padding(20)
                // buttons
                VStack {
                    HStack {
                        Button(action: {showingSettings = true}) {
                            Image(systemName: "info.circle")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                        }
                        .sheet(isPresented: $showingSettings, content: {
                            SettingsView(currentChallenge: self.distanceChallenge, isPresented: $showingSettings)
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
        ContentView()
            .previewDevice("iPhone 12 Pro Max")
        
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("LLLL")
        return df.string(from: self)
    }
}


