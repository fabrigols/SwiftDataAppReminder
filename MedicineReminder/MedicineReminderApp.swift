//
//  MedicineReminderApp.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 01/02/24.
//

import SwiftUI
import SwiftData

@main
struct MedicineReminderApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: [AppIdea.self, AppFeature.self])
    }
}
