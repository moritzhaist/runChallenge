//
//  EXTRunChallengeWidget.swift
//  EXTRunChallengeWidget
//
//  Created by Moritz Haist on 20.02.21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @AppStorage("sumOfRunsMonth", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var value: Double = Double()
    
    // updated in SettingsView
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallengeApp"))
    var distance: Double = 50.00
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), value: value, distance: distance)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), value: value, distance: distance)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, value: value, distance: distance)
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
    
}

struct RunChallengeWidgetEntryView : View {
    
    
    
    var entry: Provider.Entry
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
            VStack {
                // circle
                VStack {
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(0.75, 1.0)))
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
                .background(Color(".red"))
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
    
}

struct EXTRunChallengeWidget_Previews: PreviewProvider {
    static var previews: some View {
        RunChallengeWidgetEntryView(entry: SimpleEntry(date: Date(), value: 120.00, distance: 200.00))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
