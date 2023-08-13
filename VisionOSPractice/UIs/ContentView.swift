//
//  ContentView.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/6/27.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        WindowBasedDemoView()
            .ornament(attachmentAnchor: .scene(alignment: .bottom), contentAlignment: .center) {
                VStack {
                    Text("Detalle del personaje")
                }
                .frame(width: 400, height: 60)
                .background(.green)
//                #if os(xrOS)
//                .glassBackgroundEffect()
//                #endif
                .modifier(GlassEffectForXrOS())
            }
    }
}

#Preview {
    ContentView()
}
