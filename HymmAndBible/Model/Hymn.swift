//
//  Hymm.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/5/26.
//

import Foundation


struct Hymn: Identifiable {
	let id = UUID()
	let number: Int
	let title: String
	
	var filename: String {
		return "hymn_\(String(format: "%03d", number))"
	}
	
	var url: URL? {
		Bundle.main.url(forResource: filename, withExtension: "mp3")
	}
}
