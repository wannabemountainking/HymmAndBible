//
//  Extensions.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/2/26.
//

import Foundation
import AVFAudio


extension TimeInterval {
	var runningTime: String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		return formatter.string(from: self) ?? "00:00"
	}
}

extension Notification {
	
	var interruptionType: AVAudioSession.InterruptionType? {
		guard let userInfo = self.userInfo,
			  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
			  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return nil }
		return type
	}
	
	var interruptionOptions: AVAudioSession.InterruptionOptions? {
		guard let userInfo = self.userInfo,
			  let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return nil}
		let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
		return options
	}
}
