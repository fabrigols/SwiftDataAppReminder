//
//  ContentView.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 01/02/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	
	@Query(
		filter: #Predicate<AppIdea> { $0.isArchived == false },
		sort: \.creationDate,
		order: .reverse 
	) var ideas: [AppIdea]
	
	@State private var showAddDialog = false
	
	@State private var newName = ""
	@State private var newDescription = ""
	
	var favoriteIdeas: [AppIdea] {
		ideas.filter { $0.isFavorite }
	}
	
	var nonFavoriteIdeas: [AppIdea] {
		ideas.filter { !$0.isFavorite }
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if ideas.isEmpty {
					ContentUnavailableView("No App Ideas", systemImage: "square.stack.3d.up.slash", description: Text("Tapp add to create your first app idea"))
				} else {
					List {
						Section("Favorites") {
							ForEach(favoriteIdeas) {
								AppIdeasListRow(idea: $0)
							}

						}
						
						Section("All") {
							ForEach(nonFavoriteIdeas) {
								AppIdeasListRow(idea: $0)
							}
						}
					}
				}
			}
			.navigationTitle("App ideas")
			.navigationDestination(for: AppIdea.self) {
				EditAppIdeaView(idea: $0)
				
			}
			.toolbar {
				Button("Add") {
					showAddDialog.toggle()
				}
			}
			.sheet(isPresented: $showAddDialog) {
				NavigationStack {
					Form {
						TextField("Name", text: $newName)
						
						TextField("Description", text:$newDescription, axis: .vertical)
					}
					.navigationTitle("New App Idea")
					.toolbar {
						Button("Dismiss") {
							showAddDialog.toggle()
							
						}
						
						Button("Save") {
							let idea = AppIdea(name: newName, detailedDescription: newDescription)
							modelContext.insert(idea)
							showAddDialog.toggle()
							
						}
					}
					.onDisappear {
						newName = ""
						newDescription = ""
					}

				}
				.presentationDetents([.medium])
			}
		}
	}
}

//#Preview {
//	ContentView()
//		.modelContainer(for: [AppIdea.self, AppFeature.self], inMemory: true)
//}
