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
	var errorMessages: [String] = []
	var isPlaying: Bool = false
	
	var eventHandler = PlayerEventHandler()
	
	private override init() {
		super.init()
		eventHandler.onFinish = { [weak self] in
			guard let self else {return}
			self.isPlaying = false
		}
	}
	
	func playHymm() {
		
		// 1. player가 있는지 확인하고 (있으면 player 안만들고 없으면 만든다)
		if player == nil {
			guard let url = Bundle.main.url(forResource: "untilNow", withExtension: "mp3") else {
				errorMessages.append("URL 경로를 확인하세요")
				return
			}
			
			do {
				player = try AVAudioPlayer(contentsOf: url)
				player?.delegate = eventHandler
			} catch {
				errorMessages.append(error.localizedDescription)
			}
		}
		
		// 2. 실행중이면 일시정지, 실행중이 아니면 재생
		switch isPlaying {
		case true: player?.pause()
		case false: player?.play()
		}
		
		// 3. isPlaying을 토글해서 isPlaying의 상태가 변한 것을 바로 반영한다
		isPlaying.toggle()
	}
}

final class PlayerEventHandler: NSObject, AVAudioPlayerDelegate {
	
	var onFinish: (() -> Void)?
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		print("음악이 끝났음")
		onFinish?()
	}
}
