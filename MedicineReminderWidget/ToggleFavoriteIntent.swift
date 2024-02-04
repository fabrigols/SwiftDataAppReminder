//
//  ToggleFavoriteIntent.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 03/02/24.
//

import AppIntents
import SwiftData

struct ToggleFavoriteIntent: AppIntent {
	
	
	static var title: LocalizedStringResource = "Toggle Favorite"
	static var description: IntentDescription? = "Toggles wether an app idea is favorited."
	
	@Parameter(title: "App Idea Name")
	var appIdeaName: String
	
	init() {
		appIdeaName = ""
	}
	
	init(appIdeaName: String) {
		self.appIdeaName = appIdeaName
	}
	
	func perform() async throws -> some IntentResult {
		guard let modelContainer = try? ModelContainer(for: AppIdea.self) else {
			return .result()
		}
		let descriptor = FetchDescriptor<AppIdea>(predicate: #Predicate { idea in
			idea.name == appIdeaName
		})
		let appIdeas = try? await modelContainer.mainContext.fetch(descriptor)
		
		if let idea = appIdeas?.first {
			let isFavorite = idea.isFavorite
			idea.isFavorite = !isFavorite
		}
		
		return .result()
	}
}
