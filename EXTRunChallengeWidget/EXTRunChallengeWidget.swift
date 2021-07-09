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
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), value: value)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), value: value)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        
        
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, value: value)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let value: Double
    
}

struct RunTrackerWidgetEntryView : View {
    
   

    var entry: Provider.Entry
    

    var body: some View {
        Text("👟")
        Text("")
        Text("\(String(format: "%.3f", entry.value)) km")
        
    }
    
   
}

@main

struct RunTrackerWidget: Widget {
    
    

    let kind: String = "RunTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RunTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
    
}

