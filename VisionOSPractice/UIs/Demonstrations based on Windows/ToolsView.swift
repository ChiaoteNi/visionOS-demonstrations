//
//  ToolsView.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/7/7.
//

import SwiftUI

private struct ToolsBarItemModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.text)
//            .padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .hoverEffect()
            #if os(xrOS)
            .offset(z: -1)
            #endif
    }
}

// This demo shows a potential way to create a buttons group with varying z offset
// You can extend the usage to create some control bar that is similar to the native keyboard in the VisionOS
struct ToolsView: View {

    @State var isToolsBarExpended = false

    var body: some View {
        toolsBar()
    }

    @ViewBuilder
    private func toolsBar() -> some View {
        ZStack {
            toolsBarItem(
                title: "開始規劃",
                image: Image(systemName: "checkmark")
            )
            .modifier(ToolsBarItemModifier())
            .offset(
                x: isToolsBarExpended ? -30 : 0,
                y: isToolsBarExpended ? -60 : 0
            )
            .modifier(ZOffsetForXrOS(offset: isToolsBarExpended ? 10 : 0))
            .opacity(isToolsBarExpended ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.20),
                value: isToolsBarExpended
            )

            toolsBarItem(
                title: "目前清單",
                image: Image(systemName: "list.dash")
            )
            .modifier(ToolsBarItemModifier())
            .offset(x: isToolsBarExpended ? -65 : 0)
            .modifier(ZOffsetForXrOS(offset: isToolsBarExpended ? 20 : 0))
            .opacity(isToolsBarExpended ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.25),
                value: isToolsBarExpended
            )

            toolsBarItem(
                title: "切換模式",
                image: Image(systemName: "rectangle.2.swap")
            )
            .modifier(ToolsBarItemModifier())
            .offset(
                x: isToolsBarExpended ? -30 : 0,
                y: isToolsBarExpended ? 60 : 0
            )
            .modifier(ZOffsetForXrOS(offset: isToolsBarExpended ? 30 : 0))
            .opacity(isToolsBarExpended ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.3),
                value: isToolsBarExpended
            )

            toolsBarItem(image: Image(systemName: "arrow.left"))
                .modifier(ToolsBarItemModifier())
                .rotationEffect(isToolsBarExpended ? .degrees(180) : .zero)
                .animation(.easeInOut, value: isToolsBarExpended)
                .onTapGesture {
                    isToolsBarExpended.toggle()
                }
        }

    }

    @ViewBuilder
    func toolsBarItem(title: String? = nil, image: Image) -> some View {
        VStack {
            image
                .resizable()
                .frame(width: 20, height: 20)
            if let title {
                Text(verbatim: title)
                    .font(.caption)
            }
        }
        .background(.clear)
    }
}

#Preview {
    ToolsView()
}
