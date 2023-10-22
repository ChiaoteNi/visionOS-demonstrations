//
//  TDColorPicker.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/22.
//

import SwiftUI

struct TDColorPicker: View {

    @EnvironmentObject var globalStateStore: GlobalStateStore

    var body: some View {
        ColorPicker(selection: Binding(get: {
            globalStateStore.currentColor
        }, set: { newValue, transaction in
            globalStateStore.currentColor = newValue
        }), supportsOpacity: true) {
            Text("Color Picker")
        }
        .glassBackgroundEffect(displayMode: .always)
        .frame(width: 200, height: 100)
    }
}

#Preview {
    TDColorPicker()
}
