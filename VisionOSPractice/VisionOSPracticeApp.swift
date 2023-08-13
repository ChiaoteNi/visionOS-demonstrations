//
//  VisionOSPracticeApp.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/6/27.
//

import SwiftUI

@main
struct VisionOSPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(xrOS)
        .windowStyle(.volumetric)
        #endif
//        .defaultSize(Size3D(width: 100, height: 100, depth: 100), in: .feet)

//        ImmersiveSpace(id: "ImmersiveSpace") {
////            ImmersiveView()
//        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
