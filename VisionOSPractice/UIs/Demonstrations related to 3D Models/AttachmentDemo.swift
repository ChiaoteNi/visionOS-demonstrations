//
//  AttachmentDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/8/15.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct AttachmentDemo: View {

    private enum Name {
        static var venus = "Venus"
        static var neptune = "Neptune"
    }

    @State private var neptune: Entity?
    @State private var venus: Entity?

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(
                named: "Planet",
                in: realityKitContentBundle
            ) else {
                return
            }

            // Add entities to the content
            venus = scene.findEntity(named: Name.venus)
            neptune = scene.findEntity(named: Name.neptune)
            [venus, neptune]
                .compactMap { $0 }
                .forEach { content.add($0) }

            // Add attachments to the entities
            if let attachment = attachments.entity(for: Name.venus) {
                attachment.position = [0, 0, 0.1]
                venus?.addChild(attachment)
            }
            if let attachment = attachments.entity(for: Name.neptune) {
                attachment.position = [0, 0.1, 0.1]
                neptune?.addChild(attachment)
            }

        } attachments: {
//            Color.orange
//                .frame(width: 50, height: 150)
//                .tag(Name.neptune)
            Text(verbatim: Name.neptune)
                .font(.system(size: 24))
                .glassBackgroundEffect()
                .tag(Name.neptune)

            Text(verbatim: Name.venus)
                .font(.system(size: 36))
                .glassBackgroundEffect()
                .tag(Name.venus)
        }
        .gesture(
            // Attempt to drag the entity, and you will observe the attachment moving along with the entity.
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let parent = value.entity.parent else { return }
                    let position = value.convert(value.location3D, from: .local, to: parent)
                    value.entity.position = position
                }
        )
    }
}

#Preview {
    AttachmentDemo()
}
