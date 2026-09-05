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
import UIKit

@Observable
final class AudioPlaybackManager: NSObject {
	
	static let shared = AudioPlaybackManager()
	
	let hymns: [Hymn] = [
		Hymn(number: 1, title: "만복의 근원 하나님"),
		Hymn(number: 2, title: "이 천지간 만물들아"),
		Hymn(number: 3, title: "지금까지 지내온 것")
	]
	var currentIndex: Int = 0
	
	var player: AVAudioPlayer? = nil
	
	var lastErrorMessage: String = "에러 없음"
	var isPlaying: Bool = false
	var currentTime: Double = 0
	var isDragging: Bool = false
	var timer: Timer? = nil
	var savedTime: Double = 0
	
	var eventHandler = PlayerEventHandler()
	
	private override init() {
		super.init()

		// TODO: - UserDefault에서 초기 설정 가져오기
		savedTime = UserDefaults.standard.double(forKey: "lastPlaybackPosition")
		
		// AVAudioSession 설정 및 활성화 (1회 실행, setCategory(.playback 설정)
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback) // 오디오 세션 카테고리 설정
			try audioSession.setActive(true) // 오디오 세션 활성화
		} catch {
			lastErrorMessage = error.localizedDescription
			print("AVAudionSession 애러 발생")
		}
		
		// 잠금화면 버튼 설정(재생과 일시멈춤 버튼 전용)
		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.playCommand.addTarget { [weak self] event in
			guard let self else {return .commandFailed}
			self.togglePlayback()
			return .success
		}
		commandCenter.pauseCommand.addTarget { [weak self] event in
			guard let self else {return .commandFailed}
			self.togglePlayback()
			return .success
		}
		
		// 전화 등의 interruption에 대응하는 코드 (전화가 오면 노래 일시정지(이미 일시정지 중이면 그냥 놔둠), 이미 일시정지 중의 것은 독립적으로 실행)
		NotificationCenter.default.addObserver(
			forName: AVAudioSession.interruptionNotification,
			object: nil,
			queue: .main,
			using: { [weak self] notification in
				guard let self = self,
					  let type = notification.interruptionType else { return }
				
				switch type {
				case .began:
					if self.isPlaying {
						self.togglePlayback()
					}
				case .ended:
					guard let options = notification.interruptionOptions else { return }
					if options.contains(.shouldResume) {
						self.togglePlayback()
					}
				@unknown default:
					break
				}
			}
		)
		
		// 백그라운드로 나간 시점에 currentTime 저장하기 등록
		NotificationCenter.default.addObserver(
			forName: UIApplication.didEnterBackgroundNotification,
			object: nil,
			queue: .main,
			using: { [weak self] _ in
				guard let self else {return}
				UserDefaults.standard.set(self.currentTime, forKey: "lastPlaybackPosition")
			}
		)
		
		eventHandler.onFinish = { [weak self] in
			guard let self else {return}
			self.isPlaying = false
			self.timer?.invalidate()
			self.timer = nil
			
			if self.currentIndex == self.hymns.count - 1 {
				self.currentIndex = 0
			} else {
				self.currentIndex += 1
			}
			self.playSong(at: self.currentIndex)
			self.currentTime = 0
		}
		
		
	}
	
	func togglePlayback() {
		
		if player != nil {
			if isPlaying {
				pauseHymn()
			} else {
				resumeHymn()
			}
		} else {
			playSong(at: currentIndex)
		}
		
		// 3. isPlaying을 토글해서 isPlaying의 상태가 변한 것을 바로 반영한다
		isPlaying.toggle()
		
		// 4. 잠금화면 표시 목록 설정
		updateNowPlayingInfo(
			title: hymns[currentIndex].title,
			currentTime: currentTime,
			duration: player?.duration ?? 0,
			rate: isPlaying ? 1.0 : 0.0
		)
	}
	
	func pauseHymn() {
		player?.pause()
		timer?.invalidate()
		timer = nil
		
		// 일시 정지에도 UserDefault에 currentTime 저장해 놓기 (혹시 모르니 설정)
		UserDefaults.standard.set(self.currentTime, forKey: "lastPlaybackPosition")
	}
	
	func resumeHymn() {
		player?.play()
	}
	
	func playSong(at index: Int) {
		// 무조건 player를 만들어야 함
		guard let url = hymns[index].url else {
			lastErrorMessage = "URL 경로를 확인하세요"
            print(lastErrorMessage)
			return
		}
		print(url)
		do {
			player = try AVAudioPlayer(contentsOf: url)
			player?.delegate = eventHandler
			player?.currentTime = savedTime
			savedTime = 0
			currentIndex = index
		} catch {
			lastErrorMessage = error.localizedDescription
		}
		
		// 음악 실행중이 아님. 음악을 재생시키고 timer 작동, 드래깅 중이 아닐때(손을 뗀 시점 포함) player 값을 0.1초 마다 manager 값과 동기화
		player?.play()
		isPlaying = true
		timer = Timer.scheduledTimer(
			withTimeInterval: 0.1,
			repeats: true,
			block: { [weak self] timer in
				guard let self = self,
					  !self.isDragging else { return }
				self.currentTime = self.player?.currentTime ?? 0.0
			}
		)
		
	}
	
	
	// 잠금화면 각 요소의 정보 표시
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
