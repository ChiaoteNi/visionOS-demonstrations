//
//  TestingView.swift
//  TravelApp
//
//  Created by Chiaote Ni on 2023/7/1.
//

import SwiftUI

struct TestingView: View {

    @State var isSideBarVisible: NavigationSplitViewVisibility = .all
    @State var isSheetVisible: Bool = true

    var body: some View {
//        GeometryReader(content: { geometry in
//            zStack()
//                .frame(width: 10, height: 10)
    //        overLayers()
        navigationSplitView()
//        })
//            .background(.blue)
#if os(xrOS)
            .ornament(attachmentAnchor: .scene(alignment: .bottom)) {
                VStack {
                    Text("Detalle del personaje")
                }
                .frame(width: 400, height: 60)
//                .background(.green)
//                .glassBackgroundEffect()
                .modifier(GlassEffectForXrOS())
            }
            .ornament(attachmentAnchor: .scene(alignment: .topLeading)) {
                VStack {
                    Text("Detalle del personaje")
                }
                .frame(width: 400, height: 60)
//                .background(.green)
//                .glassBackgroundEffect()
                .modifier(GlassEffectForXrOS())
            }
//            .sheet(isPresented: $isSheetVisible) {
//                Text(verbatim: "Sheet")
//            }
            .overlay {
                ToolsView()
//                    .background(Color.red)
//                    .offset(z: 30)
                    .modifier(ZOffsetForXrOS(offset: 100))
                    .offset(x: 600)
                    .background(Color.gray)
//                    .glassBackgroundEffect()
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
#endif
    }

    @ViewBuilder
    private func overLayers() -> some View {
        Text("Hello, World!")
            .background(.red)
            .overlay {
                Text("Hello, World!")
                    .background(.ultraThinMaterial)
//#if os(xrOS)
//                    .offset(z: 50)
                    .modifier(ZOffsetForXrOS(offset: 50))
//#endif
                    .modifier(OffsetLeft())
            }
            .overlay {
                Text("Hello, World!")
                    .background(.ultraThinMaterial)
//#if os(xrOS)
//                    .offset(z: 100)
                    .modifier(ZOffsetForXrOS(offset: 100))
//#endif
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
//#if os(xrOS)
//                .offset(z: 50)
                .modifier(ZOffsetForXrOS(offset: 50))
//#endif
                .modifier(OffsetLeft())
            Text("Hello, World!")
                .background(.red)
//#if os(xrOS)
//                .offset(z: 100)
                .modifier(ZOffsetForXrOS(offset: 100))
//#endif
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
    TestingView()
}
