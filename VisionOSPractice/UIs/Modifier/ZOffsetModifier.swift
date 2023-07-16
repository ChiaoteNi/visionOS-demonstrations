//
//  ZOffsetModifier.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/7/13.
//

import Foundation
import SwiftUI

struct ZOffsetForXrOS: ViewModifier {

    let offset: CGFloat

    func body(content: Content) -> some View {
        content
        #if os(xrOS)
//            .offset(z: offset)
        #endif
    }
}
