//
//  GlassEffect.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/7/13.
//

import Foundation
import SwiftUI

struct GlassEffectForXrOS: ViewModifier {

    func body(content: Content) -> some View {
        content
        #if os(visionOS)
            .glassBackgroundEffect()
        #endif
    }
}
