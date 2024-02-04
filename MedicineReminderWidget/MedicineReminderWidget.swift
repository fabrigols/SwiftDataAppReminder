//
//  MedicineReminderWidget.swift
//  MedicineReminderWidget
//
//  Created by Fabrício Masiero on 03/02/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
	@MainActor func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), appIdeas: getAppIdeas())
	}
	
	@MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), appIdeas: getAppIdeas())
		completion(entry)
	}
	
	@MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let timeline = Timeline(entries: [SimpleEntry(date: .now, appIdeas: getAppIdeas())], policy: .after(.now.advanced(by: 60 * 5)))
		completion(timeline)
	}
	
	@MainActor
	private func getAppIdeas() -> [AppIdea] {
		guard let modelContainer = try? ModelContainer(for: AppIdea.self) else {
			return []
		}
		let descriptor = FetchDescriptor<AppIdea>(predicate: #Predicate { idea in idea.isArchived == false })
		let appIdeas = try? modelContainer.mainContext.fetch(descriptor)
		
		return appIdeas ?? []
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let appIdeas: [AppIdea]
}

struct MedicineReminderWidgetEntryView : View {
	var entry: Provider.Entry
	
	var body: some View {
		VStack {
			ForEach(entry.appIdeas) { idea in
				Button(intent: ToggleFavoriteIntent(appIdeaName: idea.name)) {
					HStack {
						Image(systemName: idea.isFavorite ? "star.fill" : "star")
							.foregroundStyle(.yellow)
						Spacer()
						Text(idea.name)
					}
				}
			}
		}
	}
}

struct MedicineReminderWidget: Widget {
	let kind: String = "MedicineReminderWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			MedicineReminderWidgetEntryView(entry: entry)
				.containerBackground(.background, for: .widget)
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
	}
}

