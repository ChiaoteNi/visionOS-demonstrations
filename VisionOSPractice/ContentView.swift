//
//  ContentView.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/6/27.
//

import SwiftUI
//import RealityKit
//import RealityKitContent

struct ContentView: View {

    var body: some View {
//        // MARK: Part I - 2D
//        ToolsView()
//        WindowBasedDemo()

//        // MARK: Part II - 3D
//        Model3DAndRealityViewDemo()
//        InteractWithEntityDemo()
//        AttachmentDemo()
//        AnimationDemo()

        // MARK: Part III - Advanced cases
#if os(visionOS)
//        Create3DPlanesDemo()
//        ThreeDimensionCanvasDemo()

        // MARK: Part IV - Immersive Space
        ImmersiveDemoEntry()

#endif
    }

}

#Preview {
    ContentView()
}
