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
                ZStack(alignment: .leading) {
                    let totalWidth = geo.size.width
                    // Background
                    Capsule()
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .frame(height: 12)
                        .frame(maxWidth: .infinity)
                    // Content
                    Circle()
                        .foregroundStyle(Color.green.opacity(0.8))
                        .frame(width: 12, height: 12)
                        .offset(x: sliderValue * totalWidth)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    let locationX = max(6, min(value.location.x, totalWidth - 6))
                                    sliderValue = locationX / totalWidth
                                })
                        )
                    Capsule()
                        .foregroundStyle(Color.green.opacity(0.8))
                        .frame(width: sliderValue * totalWidth + 6, height: 12)
                } //:ZSTACK
            } //:GEOMETRY
            .frame(height: 12)
        } //:VSTACK
    }
}

#Preview {
    SliderComponent()
}
