//
//  MainView.swift
//  HymmAndBible
//
//  Created by YoonieMac on 8/31/26.
//

import SwiftUI

struct MainView: View {
	
	@State private var audioManager: AudioPlaybackManager = .shared
	
    var body: some View {
        Spacer()
		Button {
			// Action
			audioManager.playHymm()
		} label: {
			Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
				.resizable()
				.scaledToFit()
				.frame(width: 35, height: 35)
				.foregroundStyle(Color.white)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.blue)
						.frame(width: 100, height: 70)
				)
		}
		.padding()
		
		ForEach(audioManager.errorMessages, id: \.self) { error in
			Text(error)
		}
		
		Spacer()
		
		Button {
			// Action
			audioManager.errorMessages.removeAll()
		} label: {
			Text("에러 메시지 삭제")
				.font(.title)
				.foregroundStyle(.purple)
		}
    }
}

#Preview {
    MainView()
}
