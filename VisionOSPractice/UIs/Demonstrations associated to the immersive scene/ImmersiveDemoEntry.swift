//
//  ImmersiveDemoEntry.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/19.
//

import SwiftUI

struct ImmersiveDemoEntry: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            Button {
                Task {
                    await openImmersiveSpace(id: "ImmersivePlayground", value: "Painting")
                }
            } label: {
                Text(verbatim: "Doodle")
                    .font(.largeTitle)
            }
            Button {
                Task {
                    await dismissImmersiveSpace()
                }
            } label: {
                Text(verbatim: "Leave immersive space")
                    .font(.largeTitle)
            }

        }

    }
}

#Preview {
    ImmersiveDemoEntry()
}
