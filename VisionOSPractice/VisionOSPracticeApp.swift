//
//  VisionOSPracticeApp.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/6/27.
//

import SwiftUI

final class GlobalStateStore: ObservableObject {
    @Published var currentColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
}

@main
struct VisionOSPracticeApp: App {

    @StateObject var globalStateStore = GlobalStateStore()

    var body: some Scene {
        WindowGroup("main", id: "main") {
            ContentView()
                .environmentObject(globalStateStore)
        }
        #if os(xrOS)
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
    }
}
