//
//  Extensions.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/2/26.
//

import Foundation


extension Double {
	var runningTime: String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		return formatter.string(from: self) ?? "00:00"
	}
}
