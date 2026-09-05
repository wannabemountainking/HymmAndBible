//
//  MainView.swift
//  HymmAndBible
//
//  Created by YoonieMac on 8/31/26.
//

import SwiftUI
import AVFAudio

struct MainView: View {
	
	var audioManager: AudioPlaybackManager = .shared
	
    var body: some View {
		VStack(spacing: 20) {
			Text("찬송가 목록")
				.font(.largeTitle)
				.fontWeight(.heavy)
			
			Divider()
			
			List {
				ForEach(Array(audioManager.hymns.enumerated()), id: \.element.id) { index, hymn in
					HymnRowView(
						index: index,
						hymn: hymn,
						manager: audioManager
					)
					.onTapGesture {
						audioManager.playSong(at: index)
					}
				} //:LOOP
			} //:LIST
			
			Spacer()
			
			Divider()
			
            if audioManager.player != nil {
                PlayerView(manager: audioManager)
                    .transition(.slide.combined(with: .blurReplace))
            }
		} //:VSTACK
        .animation(.easeInOut, value: audioManager.isPlaying)
    }
}

#Preview {
    MainView()
}
