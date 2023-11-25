//
//  statusTrain.swift
//  statusTrain
//
//  Created by Paolo Dionesalvi on 25/11/23.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.flutterTrain"

struct Provider: TimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Placheholder", description: "Placheholder")
    }

    func getSnapshot( in context: Context, completion: @escaping (SimpleEntry) -> ())  {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = SimpleEntry(date: .now, title: data?.string(forKey: "title") ?? "?", description: data?.string(forKey: "description") ?? "??")
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
            
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
    
}

struct statusTrainEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.description)
        }
    }
}

struct statusTrain: Widget {
    let kind: String = "statusTrain"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            statusTrainEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Stato Treno")
        .description("Controlla in tempo reale quanto manca al passimo tram")
    }
}



#Preview(as: .systemSmall) {
    statusTrain()
} timeline: {
    SimpleEntry(date: .now, title: "Ops", description: "Noooo")
}
