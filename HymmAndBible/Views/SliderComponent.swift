//
//  SliderComponent.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/8/26.
//

import SwiftUI
import AVFAudio

struct SliderComponent: View {
	
	@Bindable var manager: AudioPlaybackManager
	
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    let totalWidth = geo.size.width
                    // Background
                    Capsule()
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .frame(height: 12)
                        .frame(maxWidth: .infinity)
                    // Content
					Capsule()
						.foregroundStyle(Color.green.opacity(0.8))
						.frame(width: (manager.currentTime / (manager.player?.duration ?? 1)) * totalWidth + 12, height: 12)
                    Circle()
                        .foregroundStyle(Color.green.opacity(0.8))
                        .frame(width: 12, height: 12)
						.offset(x: (manager.currentTime / (manager.player?.duration ?? 1)) * totalWidth)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
									manager.isDragging = true
                                    let locationX = max(0, min(value.location.x, totalWidth))
									manager.currentTime = (locationX / totalWidth) * (manager.player?.duration ?? 1)
                                })
								.onEnded(
									{ value in
										manager.isDragging = false
										manager.player?.currentTime = manager.currentTime
										manager.updateNowPlayingInfo(
											title: manager.hymns[manager.currentIndex].title,
											currentTime: manager.currentTime,
											duration: manager.player?.duration ?? 1,
											rate: manager.isPlaying ? 1.0 : 0.0
										)
								})
                        )

                } //:ZSTACK
            } //:GEOMETRY
            .frame(height: 12)
        } //:VSTACK
    }
}

#Preview {
	SliderComponent(manager: AudioPlaybackManager.shared)
}
