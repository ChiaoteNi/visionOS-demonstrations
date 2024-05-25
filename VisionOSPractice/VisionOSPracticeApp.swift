//
//  VisionOSPracticeApp.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/6/27.
//

import SwiftUI

final class GlobalStateStore: ObservableObject {
    @Published var currentColor = CGColor(red: 0.5, green: 0.5, blue: 0, alpha: 1)
}

@main
struct VisionOSPracticeApp: App {

    @StateObject var globalStateStore = GlobalStateStore()
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some Scene {
        WindowGroup("main", id: "main") {
            ContentView()
                .environmentObject(globalStateStore)
        }
        #if os(visionOS)
        .windowStyle(.volumetric)
        #endif

        // This window won't display until you call @Environment(\.openWindow) var openWindow
        WindowGroup(id: "sidePanel", for: String.self) { value in
            switch value.wrappedValue {
            case "colorPicker":
                TDColorPicker()
                    .environmentObject(globalStateStore)
            default:
                EmptyView()
            }
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersivePlayground", for: String.self) { destination in
            switch destination.wrappedValue {
            case "Painting":
                ImmersiveDoodleDemo()
                    .environmentObject(globalStateStore)
            case "ParticalsEmitter":
                // TODO: next demonstration
                EmptyView()
            default:
                EmptyView()
            }
        }.immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
