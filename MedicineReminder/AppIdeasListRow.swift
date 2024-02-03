//
//  AppIdeasListRow.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 01/02/24.
//

import SwiftUI
import SwiftData

struct AppIdeasListRow: View {
	@Environment(\.modelContext) private var modelContext
	
	var idea: AppIdea
	
	var body: some View {
		NavigationLink(value: idea) {
			VStack(alignment: .leading) {
				Text(idea.name)
				
				Text(idea.detailedDescription)
					.textScale(.secondary)
					.foregroundStyle(.secondary)
			}
		}
		.swipeActions(edge: .trailing, allowsFullSwipe: false) {
			Button(role: .destructive) {
				idea.isArchived = true
			} label: {
				Label("Archive", systemImage: "archivebox")
			}
		}
		.swipeActions(edge: .leading, allowsFullSwipe: true) {
			Button(role: .destructive) {
				idea.isFavorite.toggle()
			} label: {
				Label("Favorite", systemImage: idea.isFavorite ? "star.slash" : "star")
			}
			.tint(.yellow)
		}
		.sensoryFeedback(.decrease, trigger: idea.isArchived)
		.sensoryFeedback(.increase, trigger: idea.isFavorite)
	}
}
