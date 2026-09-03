//
//  AudioPlaybackManager.swift
//  HymmAndBible
//
//  Created by YoonieMac on 8/30/26.
//

import Foundation
import Observation
import AVFAudio
import MediaPlayer

@Observable
final class AudioPlaybackManager: NSObject {
	
	static let shared = AudioPlaybackManager()
	
	var player: AVAudioPlayer? = nil
	var lastErrorMessage: String = "에러 없음"
	var isPlaying: Bool = false
	var currentTime: Double = 0
	var isDragging: Bool = false
	var timer: Timer? = nil
	
	var eventHandler = PlayerEventHandler()
	
	private override init() {
		super.init()
		eventHandler.onFinish = { [weak self] in
			guard let self else {return}
			self.isPlaying = false
			self.currentTime = 0
			self.timer?.invalidate()
			self.timer = nil
		}
		
		// AVAudioSession 설정 및 활성화 (1회 실행)
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback) // 오디오 세션 카테고리 설정
			try audioSession.setActive(true) // 오디오 세션 활성화
		} catch {
			lastErrorMessage = error.localizedDescription
			print("AVAudionSession 애러 발생")
		}
		
		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.playCommand.addTarget { [weak self] event in
			guard let self else {return .commandFailed}
			self.playHymm()
			return .success
		}
		commandCenter.pauseCommand.addTarget { [weak self] event in
			guard let self else {return .commandFailed}
			self.playHymm()
			return .success
		}
		
		NotificationCenter.default.addObserver(
			forName: AVAudioSession.interruptionNotification,
			object: nil,
			queue: .main,
			using: { [weak self] noti in
				guard let self = self,
					  let userInfo = noti.userInfo,
					  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
					  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
				
				switch type {
				case .began:
					if self.isPlaying {
						self.playHymm()
					}
				case .ended:
					guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return}
					let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
					if options.contains(.shouldResume) {
						self.playHymm()
					}
				@unknown default:
					break
				}
				
			}
		)
	}
	
	func playHymm() {
		
		// 1. player가 있는지 확인하고 (있으면 player 안만들고 없으면 만든다)
		if player == nil {
			guard let url = Bundle.main.url(forResource: "untilNow", withExtension: "mp3") else {
				lastErrorMessage = "URL 경로를 확인하세요"
				return
			}
			
			do {
				player = try AVAudioPlayer(contentsOf: url)
				player?.delegate = eventHandler
			} catch {
				lastErrorMessage = error.localizedDescription
			}
		}
		
		// 2. 실행중이면 일시정지, 실행중이 아니면 재생
		switch isPlaying {
		case true: player?.pause()
			timer?.invalidate()
			timer = nil
		case false:
			// 음악 실행중이 아닐때 음악을 재생시키고 timer 작동, 드래깅 중이 아닐때(손을 뗀 시점 포함) player 값을 0.1초 마다 manager 값과 동기화
			player?.play()
			timer = Timer.scheduledTimer(
				withTimeInterval: 0.1,
				repeats: true,
				block: { [weak self] timer in
					guard let self else {return}
					guard !self.isDragging else { return }
					self.currentTime = self.player?.currentTime ?? 0
				}
			)
		}
		
		// 3. isPlaying을 토글해서 isPlaying의 상태가 변한 것을 바로 반영한다
		isPlaying.toggle()
		
		// 4. 잠금화면 표시 목록 설정
		updateNowPlayingInfo(
			title: "찬송가 301장",
			currentTime: currentTime,
			duration: player?.duration ?? 0,
			rate: isPlaying ? 1.0 : 0.0
		)
	}
	
	func updateNowPlayingInfo(title: String, currentTime: Double, duration: Double, rate: Double) {
		
		var nowPlayingInfo: [String: Any] = [:]
		
		nowPlayingInfo[MPMediaItemPropertyTitle] = title
		nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
		nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
		nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
		
		MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
	}
}

final class PlayerEventHandler: NSObject, AVAudioPlayerDelegate {
	
	var onFinish: (() -> Void)?
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		print("음악이 끝났음")
		onFinish?()
	}
}
