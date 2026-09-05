//
//  HymnRowView.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/5/26.
//

import SwiftUI

struct HymnRowView: View {
	
	let index: Int
	let hymn: Hymn
	var manager: AudioPlaybackManager
	
    var body: some View {
		
		LazyHStack {
			if manager.currentIndex == index {
				Image(systemName: "speaker.wave.3.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 35, height: 35)
					.foregroundStyle(Color.pink)
					.padding(.trailing, 10)
			} else {
				Image(systemName: "speaker.slash.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30)
					.foregroundStyle(Color.gray.opacity(0.5))
					.padding(.trailing, 10)
			}
			
			HStack {
				Text("\(hymn.number)장")
					.padding(.trailing, 20)
				Text(hymn.title)
			}
			.font(manager.currentIndex == index ? .title : .title3)
			.fontWeight(manager.currentIndex == index ? .bold : .medium)
		} //:HSTACK
    }
}

#Preview {
	let manager = AudioPlaybackManager.shared
	HymnRowView(index: 0, hymn: manager.hymns[0], manager: manager)
}
