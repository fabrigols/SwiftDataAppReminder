//
//  EditAppIdeaView.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 01/02/24.
//

import SwiftUI
import SwiftData

struct EditAppIdeaView: View {
	@Environment(\.modelContext) private var modelContext
	@Bindable var idea: AppIdea
	
	@State private var newFeatureDescription = ""
	
    var body: some View {
		Form {
			TextField("Name", text: $idea.name)
			
			TextField("Description", text: $idea.detailedDescription, axis: .vertical)
			
			Section("Features") {
				TextField("New Features", text: $newFeatureDescription)
					.onSubmit {
						let feature = AppFeature(detailedDescription: newFeatureDescription, creationDate: .now)
						idea.features.append(feature)
						newFeatureDescription.removeAll()
					}
				
				ForEach(idea.features) { feature in
					Text(feature.detailedDescription)
						.contextMenu {
							Button(role: .destructive) {
								idea.features.removeAll(where: { $0 == feature })
								modelContext.delete(feature)
							} label: {
								(Label("Delete", systemImage: "trash"))
							}
							
						}
				}
			}
		}
		.navigationTitle(idea.name)
	}
}

