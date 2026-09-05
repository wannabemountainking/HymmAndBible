//
//  MainView.swift
//  HymmAndBible
//
//  Created by YoonieMac on 8/31/26.
//

import SwiftUI
import AVFAudio

struct MainView: View {
	
	@State private var audioManager: AudioPlaybackManager = .shared
	
    var body: some View {
		VStack {
			Text("찬송가 301장")
				.font(.largeTitle)
				.padding(.bottom, 50)
			
			if let player = audioManager.player {
				Slider(
					value: $audioManager.currentTime,
					in: 0...player.duration,
					label: { Text("재생진행율")
					},
					minimumValueLabel: { Text("00:00") },
					maximumValueLabel: { Text(player.duration.runningTime) },
					onEditingChanged: { editing in
						audioManager.isDragging = editing
						if !editing {
							audioManager.player?.currentTime = audioManager.currentTime
							audioManager.updateNowPlayingInfo(
								title: "찬송가 301장",
								currentTime: audioManager.currentTime,
								duration: audioManager.player?.duration ?? 0,
								rate: audioManager.isPlaying ? 1.0 : 0.0
							)
						}
					}
				)
				.padding(.horizontal, 20)
				
				Text("진행된 시간: \(audioManager.currentTime.runningTime)")
			}
			
			Button {
				// Action
				audioManager.togglePlayback()
			} label: {
				Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20)
					.foregroundStyle(Color.white)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.blue)
							.frame(width: 70, height: 50)
					)
			}
			.padding(40)
		} //:VSTACK
    }
}

#Preview {
    MainView()
}
