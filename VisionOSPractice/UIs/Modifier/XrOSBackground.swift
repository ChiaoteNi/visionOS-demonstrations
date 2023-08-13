//
//  XrOSBackground.swift
//  IM in SwiftUI
//
//  Created by Chiaote Ni on 2023/7/16.
//

import Foundation
import SwiftUI

struct XrOSBackground: ViewModifier {

    func body(content: Content) -> some View {
        content
        #if os(xrOS)
            .background(.red) // Vision Pro
        #else
            .background(.blue) // Vision Pro (Design for iPad)
        #endif
    }
}
