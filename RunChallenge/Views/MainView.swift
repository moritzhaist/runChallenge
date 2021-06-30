//
//  ContentView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI

struct MainView: View {
    
    // updated in HealthKitQuery Class
    @AppStorage("sumOfRunsMonth", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var sumOfRunsMonth: Double = 0.00
    @AppStorage("sumOfRunsYear", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var sumOfRunsYear: Double = 0.00
    
    // updated in SettingsView
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var distanceChallenge: Double = 50.00
    
    @State private var showingSettings = false
    @State private var showingInfo = false
    
    let date = Date()
    let cal = Calendar(identifier: .gregorian)
    
    // methods
    func getChallengeProgress () -> Float {
        return Float(sumOfRunsMonth) / Float(distanceChallenge)
    }
    
    func getRemainingDays() -> Int {
        let monthRange = cal.range(of: .day, in: .month, for: date)!
        let daysInMonth = monthRange.count
        return daysInMonth - (date.get(.day))
    }
    
    func getYear() -> Int {
        return (date.get(.year))
    }
    
    // view
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                
                // header
                VStack(alignment: .leading) {
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
                                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                    style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270.0))
                                .foregroundColor(Color(hue: 0.509, saturation: 1.0, brightness: 1.0))
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
                            Text("\(String(format: "%.1f", (self.getChallengeProgress() * 100))) %")
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
                            Text("\(String(format: "%.2f", (self.distanceChallenge - self.sumOfRunsMonth))) km")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        Divider().background(Color.gray)
                        HStack(alignment: .center){
                            Text("Days left in Month")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(self.getRemainingDays()) days")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 1)
                        Divider().background(Color.gray)
                        HStack(alignment: .center){
                            Text("Total running distance in \(String(date.get(.year)))")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(String(format: "%.2f", self.sumOfRunsYear)) km")
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
// date extension -> getRemainingDays()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 12 Pro Max")
    }
}




