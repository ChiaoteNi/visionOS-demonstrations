//
//  ZoomInModifier.swift
//  CognitiveCards
//
//  Created by Chiaote Ni on 2023/7/13.
//

import Foundation
import SwiftUI

struct ZoomInModifier: ViewModifier {

    let scaleEffect: CGSize
    let zOffset: CGFloat
    let isFocused: Bool

    func body(content: Content) -> some View {
//        content
        #if os(xrOS)
        content
//            .offset(z: zOffset)
        #else
        content
            .scaleEffect(
                isFocused
                ? scaleEffect
                : CGSize(width: 1, height: 1)
            )
        #endif
    }
}
