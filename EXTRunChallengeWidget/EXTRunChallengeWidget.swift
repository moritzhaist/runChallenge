//
//  EXTRunChallengeWidget.swift
//  EXTRunChallengeWidget
//
//  Created by Moritz Haist on 20.02.21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // updated in HealthKitQuery Class
    @AppStorage("sumOfRunsMonth", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var sumOfRunsMonth: Double = Double()
    @AppStorage("sumOfRunsYear", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var sumOfRunsYear: Double = Double()
    // updated in SettingsView
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var distance: Double = Double()

    // methods
    func getChallengeProgress () -> Float {
        let challenge = Float(sumOfRunsMonth) / Float(distance)
        return challenge
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), value: sumOfRunsMonth, distance: distance, yearProgress: sumOfRunsYear)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), value: sumOfRunsMonth, distance: distance, yearProgress: sumOfRunsYear)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, value: sumOfRunsMonth, distance: distance, yearProgress: sumOfRunsYear)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let value: Double
    let distance: Double
    let yearProgress: Double
}

struct RunChallengeWidgetEntryView : View {
    
    let dates = Dates()
    
    
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        let progress = entry.value / entry.distance
        switch family {
        // small widget
        case .systemSmall:
            ZStack(alignment: .top) {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        ZStack {
                            Circle()
                                // to do: get progress value
                                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                                .stroke(
                                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                    style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270.0))
                                .frame(width: 70, height: 70, alignment: .center)
                                .padding(5)
                            Spacer()
                            Image("shoeIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                        }
                        .padding(10)
                    }
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        Text("\(String(format: "%.0f", entry.value)) KM / \(String(format: "%.0f", entry.distance)) KM")
                            .foregroundColor(.white)
                            .font(.system(size: 17.0, weight: .regular, design: .default))
                        Spacer()
                    }
                }
                .padding(10)
            }
        // medium widget
        case .systemMedium:
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        // circle + sum
                        ZStack {
                            Circle()
                                // to do: get progress value
                                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                                .stroke(
                                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color("mLightBlue"), location: 0.0), Gradient.Stop(color: Color("mDarkBlue"), location: 0.9990679227388822)]), startPoint: UnitPoint.bottomTrailing, endPoint: UnitPoint.topLeading),
                                    style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270.0))
                                .frame(width: 90, height: 90, alignment: .center)
                                .padding(5)
                            Text("\(String(format: "%.0f", entry.value)) KM")
                                .foregroundColor(.white)
                                .font(.system(size: 15.0, weight: .semibold, design: .default))
                        }
                        .padding(10)
                        // Table
                        VStack {
                            HStack(alignment: .center){
                                Text("Challenge")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(String(format: "%.0f", entry.distance)) KM")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 0.5)
                            Divider().background(Color.gray)
                            HStack(alignment: .center){
                                Text("KM left")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(String(format: "%.0f", (entry.distance - entry.value))) KM")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 0.5)
                            Divider().background(Color.gray)
                            HStack(alignment: .center){
                                Text("Days left")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(dates.getRemainingDays())")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 0.5)
                            Divider().background(Color.gray)
                            HStack(alignment: .center){
                                Text("Total \(String(dates.date.get(.year)))")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(String(format: "%.0f", entry.yearProgress)) KM")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(15)
                    }
                }
                .padding(10)
            }
        case .systemLarge:
            Text("")
        @unknown default:
            Text("")
        }
    }
}



@main

struct RunTrackerWidget: Widget {
    
    
    let kind: String = "RunTrackerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RunChallengeWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
        }
        // Text on widget card
        .configurationDisplayName("Run Challenge")
        .description("Check your running and challenge progress of the current month.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
    
}

struct EXTRunChallengeWidget_Previews: PreviewProvider {
    static var previews: some View {
        RunChallengeWidgetEntryView(entry: SimpleEntry(date: Date(), value: 120.00, distance: 200.00, yearProgress: 1200))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.locale, .init(identifier: "de"))
    }
}
