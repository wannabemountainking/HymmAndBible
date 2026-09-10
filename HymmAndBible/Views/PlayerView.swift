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
				HStack(spacing: 10) {
					Text("00:00")
					
					SliderComponent(manager: manager)
					
					Text(player.duration.runningTime)
				} //:HSTACK
				.padding(20)
			}//:CONDITIONAL
			
			Text("진행된 시간: \(manager.currentTime.runningTime)")
			
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
