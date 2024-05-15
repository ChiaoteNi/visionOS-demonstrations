//
//  WindowBasedDemo.swift
//  TravelApp
//
//  Created by Chiaote Ni on 2023/7/1.
//

import SwiftUI

struct WindowBasedDemo: View {

    @State var isSideBarVisible: NavigationSplitViewVisibility = .all
    @State var isSheetVisible: Bool = true

    var body: some View {
        ZStack {
            overLayers()
            zStack()
            navigationSplitView()
            ToolsView()
            // Method 1: `if os(xcOS)` every where
//                #if os(visionOS)
//                .offset(z: 100)
//                #endif
            // Method 2: create a custom ViewModifier for this
                .modifier(ZOffsetForXrOS(offset: 100))
                .offset(x: 600)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
//        #if os(visionOS)
//        .glassBackgroundEffect()
//        #endif
        .modifier(GlassEffectForXrOS())
#if os(visionOS)
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .center) {
            VStack {
                Text("Detalle del personaje")
            }
            .frame(width: 400, height: 60)
            .background(.green)
            .glassBackgroundEffect()
        }
        .ornament(attachmentAnchor: .scene(.topLeading)) {
            VStack {
                Text("Detalle del personaje")
            }
            .frame(width: 400, height: 60)
            .background(.green)
            .glassBackgroundEffect()
        }
        //            .sheet(isPresented: $isSheetVisible) {
        //                Text(verbatim: "Sheet")
        //            }
#endif
    }

    @ViewBuilder
    private func overLayers() -> some View {
        Text("Hello, World!")
            .background(.red)
            .overlay {
                Text("Hello, World!")
                    .background(.ultraThinMaterial)
//                    #if os(visionOS)
//                    .offset(z: 50)
//                    #endif
                    .modifier(ZOffsetForXrOS(offset: 50))
                    .modifier(OffsetLeft())
            }
            .overlay {
                Text("Hello, World!")
                    .background(.ultraThinMaterial)
//                    #if os(visionOS)
//                    .offset(z: 100)
//                    #endif
                    .modifier(ZOffsetForXrOS(offset: 100))
                    .modifier(OffsetRight())
            }
    }

    @ViewBuilder
    private func zStack() -> some View {
        ZStack {
            Text("Hello, World!")
                .background(.red)
            Text("Hello, World!")
                .background(.red)
//                #if os(visionOS)
//                .offset(z: 50)
//                #endif
                .modifier(ZOffsetForXrOS(offset: 50))
                .modifier(OffsetLeft())
            Text("Hello, World!")
                .background(.red)
//                #if os(visionOS)
//                .offset(z: 100)
//                #endif
                .modifier(ZOffsetForXrOS(offset: 100))
                .modifier(OffsetRight())

        }
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    private func navigationSplitView() -> some View {
        NavigationSplitView(columnVisibility: $isSideBarVisible) {
            Text("Hello, World!")
                .navigationTitle("Yo")
        } detail: {
            Text("Hello, World!")
                .navigationTitle("Yeah")
        }
    }
}

private struct OffsetLeft: ViewModifier {
    func body(content: Content) -> some View {
        content.offset(x: -500)
    }
}
private struct OffsetRight: ViewModifier {
    func body(content: Content) -> some View {
        content.offset(x: 300)
    }
}

#Preview {
    WindowBasedDemo()
}
