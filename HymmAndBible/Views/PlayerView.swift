//
//  PlayerView.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/5/26.
//

import SwiftUI
import AVFAudio

struct PlayerView: View {
	
	@Bindable var manager: AudioPlaybackManager
	
    var body: some View {
		VStack {
			Text(manager.hymns[manager.currentIndex].title)
				.font(.title3)
			if let player = manager.player {
				let _ = print(player)
				Slider(
					value: $manager.currentTime,
					in: 0...player.duration,
					label: { Text("재생진행율")
					},
					minimumValueLabel: { Text("00:00") },
					maximumValueLabel: { Text(player.duration.runningTime) },
					onEditingChanged: { editing in
						manager.isDragging = editing
						if !editing {
							manager.player?.currentTime = manager.currentTime
							manager.updateNowPlayingInfo(
								title: manager.hymns[manager.currentIndex].title,
								currentTime: manager.currentTime,
								duration: manager.player?.duration ?? 0,
								rate: manager.isPlaying ? 1.0 : 0.0
							)
						}
					}
				)
				.padding(.horizontal, 20)
				
				Text("진행된 시간: \(manager.currentTime.runningTime)")
			}
			
			Button {
				// Action
				manager.togglePlayback()
			} label: {
				Image(systemName: manager.isPlaying ? "pause.fill" : "play.fill")
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
			.buttonStyle(.plain)
		} //:VSTACK
		.frame(maxWidth: .infinity)
    }
}

#Preview {
	PlayerView(manager: .shared)
}
