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
        SimpleEntry(line: "1", stop: "1", time: "Tra 1 min", is_refreshing: true)
    }

    func getSnapshot( in context: Context, completion: @escaping (SimpleEntry) -> ())  {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = SimpleEntry(line: data?.string(forKey: "line") ?? "69", stop: data?.string(forKey: "stop") ?? "1", time: data?.string(forKey: "time") ?? "Non arriva", stop: data?.string(forKey: "is_refreshing") ?? false)
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
    let line: String
    let stop: String
    let time: String
    let is_refreshing: Bool
}

struct statusTrainEntryView : View {
    var entry: Provider.Entry
    var color = Color.orange

    if entry.is_refreshing {
        color = Color.green
    }

    var body: some View {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10, height:10)
                        .foregroundColor(Color.green)
                    VStack (alignment: .leading){
                        Text(entry.line)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .allowsTightening(true)
                        Text(entry.stop)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondary)
                            .allowsTightening(true)
                    }
                    Spacer()
                    Text("👨‍🔧")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .allowsTightening(true)
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.time)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding(.all, 10)
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
        SimpleEntry(line: "1", stop: "1", time: "Tra 1 min", is_refreshing: true)
}
