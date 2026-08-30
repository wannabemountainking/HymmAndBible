//
//  AudioPlaybackManager.swift
//  HymmAndBible
//
//  Created by YoonieMac on 8/30/26.
//

import Foundation
import Observation
import AVFoundation


@Observable
final class AudioPlaybackManager: NSObject {
	
	static let shared = AudioPlaybackManager()

	var player: AVAudioPlayer? = nil
	var errorMessage: String? = nil
	private var eventHandler = PlaybackEventHandler()
	
	private override init() {
		super.init()
		eventHandler.onFinish = {
			print("manager가 알아챔: 재생 끝남")
		}
	}
	
	func playSound() {
		guard let url = Bundle.main.url(forResource: "untilNow", withExtension: "mp3") else {return}
		do {
			player = try AVAudioPlayer(contentsOf: url)
			player?.delegate = eventHandler
			player?.play()
		} catch {
			errorMessage = "에러 원인: \(error.localizedDescription)"
		}
	}
	
}

final class PlaybackEventHandler: NSObject, AVAudioPlayerDelegate {
	
	var onFinish: (() -> Void)?
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		print("다 들었다")
		onFinish?()
	}
	
	
}
