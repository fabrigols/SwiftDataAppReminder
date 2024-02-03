//
//  AppFeature.swift
//  MedicineReminder
//
//  Created by Fabrício Masiero on 01/02/24.
//

import SwiftUI
import SwiftData


@Model
class AppFeature {
	@Attribute(.unique) var detailedDescription: String
	var creationDate: Date
	
	init(detailedDescription: String, creationDate: Date) {
		self.detailedDescription = detailedDescription
		self.creationDate = .now
	}
}
