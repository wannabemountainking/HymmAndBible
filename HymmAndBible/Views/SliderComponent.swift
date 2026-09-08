//
//  SliderComponent.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/8/26.
//

import SwiftUI

struct SliderComponent: View {
	
	@State private var offset: CGSize = .zero
	
    var body: some View {
		VStack {
			GeometryReader { geo in
				ZStack {
					// Background Color
					Color.gray.opacity(0.3)
						.ignoresSafeArea()
					// Content
					
					Circle()
						.frame(width: 10, height: 10)
						.offset(offset)
						.gesture(
							DragGesture()
								.onChanged(
									{ value in
										offset = CGSize(
											width: value.location.x,
											height: geo.size.height
										)
								})
								.onEnded(
									{ value in
										offset = CGSize(
											width: value.location.x,
											height: geo.size.height
										)
								})
						)
					
				} //:ZSTACK
				.frame(height: 3)
				.frame(maxWidth: .infinity)
				.contentShape(Rectangle())
			}
		} //:VSTACK
		.padding(10)
    }
}

#Preview {
    SliderComponent()
}
