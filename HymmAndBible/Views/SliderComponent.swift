//
//  SliderComponent.swift
//  HymmAndBible
//
//  Created by YoonieMac on 9/8/26.
//

import SwiftUI

struct SliderComponent: View {
	
	@State private var sliderValue: CGFloat = 0.0
	
    var body: some View {
		VStack(spacing: 20) {
			GeometryReader { geo in
				let totalSliderWidth = geo.size.width
				
				ZStack(alignment: .leading) {
					// Background
					Capsule()
						.fill(Color.gray.opacity(0.5))
						.frame(height: 10)
						.frame(maxWidth: .infinity)
					// Content
					
				Capsule()
					.fill(Color.green.opacity(0.8))
					.frame(height: 10)
					.frame(width: totalSliderWidth * sliderValue, height: 12)
					
				Circle()
					.fill(Color.green.opacity(0.8))
					.frame(height: 12)
					.offset(x: (totalSliderWidth * sliderValue) - 6)
					.gesture(
						DragGesture(minimumDistance: 0.0)
							.onChanged({ value in
								let locationX = max(0, min(value.location.x, totalSliderWidth))
								sliderValue = locationX / totalSliderWidth
							})
					)
				} //:ZSTACK
				
				
				
			}
			
		} //:VSTACK
    }
}

#Preview {
    SliderComponent()
}
