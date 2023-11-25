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
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10, height:10)
                        .foregroundColor(Color.orange)
                    VStack (alignment: .leading){
                        Text(entry.title)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .allowsTightening(true)
                        Text("MATIF")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondary)
                            .allowsTightening(true)
                    }
                    Spacer()
                    Text("+1.75")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .allowsTightening(true)
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.description)
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
    SimpleEntry(date: .now, title: "Ops", description: "Noooo")
}
