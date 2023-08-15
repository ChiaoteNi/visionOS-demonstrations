//
//  InteractWithEntityDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/8/15.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct InteractWithEntityDemo: View {

    @State private var telescope: Entity?
    @State private var telescope_1: Entity?
    @State private var neptune: Entity?
    @State private var venus: Entity?

    // For the Neptune
    @State
    private var currentDate = Date.now
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    // For the TapGesture
    @State
    private var timers: [Timer] = []
    @State
    private var subscriptions = Set<AnyCancellable>()

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Planet", in: realityKitContentBundle) {

//                // Method 1. Add the entire scene to content
//                content.add(scene)

                // Method 2. find each entity with name and decide which one should be added
                venus = scene.findEntity(named: "Venus")
                neptune = scene.findEntity(named: "Neptune")
                telescope = scene.findEntity(named: "Telescope")
                telescope_1 = scene.findEntity(named: "Telescope_1")

                [venus, neptune, telescope, telescope_1]
                    .compactMap { $0 }
                    .forEach { content.add($0) }

//                // The code below is identical to the one on line 40
//                // This is just preparation for the scenario to demonstrate the update with Method 1.
//                neptune = scene.findEntity(named: "Neptune")
            }
        } update: { content in
            let rotation = makeRotation(with: currentDate.timeIntervalSince1970)
//            // Case 1. To rotate the Neptune directly
//            neptune?.transform.rotation = simd_quatf(vector: simd_float4(rotation.vector))

            // Case 2. To rotate the Neptune with animation, which will create better user experience but is not the primary part for this demo.
            neptune?.updateTransform(
                scale: nil,
                rotation: simd_quatf(vector: simd_float4(rotation.vector)),
                translation: nil,
                withAnimation: true
            )
        }
        .onReceive(timer, perform: { input in
            currentDate = input
        })
        .gesture(dragEntity())
        .gesture(tapEntityToRotation())
        .scaledToFit()
    }

    func dragEntity() -> some Gesture {
        DragGesture()
//            // Case 1: Only apply gesture on a specific entity
//            .targetedToEntity(neptune ?? Entity())

            // Case 2: Apply gesture on all entities
            .targetedToAnyEntity()
            .onChanged { value in
                guard let parent = value.entity.parent else { return }
                let position = value.convert(value.location3D, from: .local, to: parent)
                value.entity.position = position
            }
    }

    func tapEntityToRotation() -> some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded({ value in
                let start = Date()
                Timer.publish(every: 0.01, on: .main, in: .common)
                    .autoconnect()
                    .sink { date in
                        let rotation = makeRotation(with: date.timeIntervalSince(start))
                        value.entity.updateTransform(
                            scale: nil,
                            rotation: simd_quatf(vector: simd_float4(rotation.vector)),
                            translation: nil,
                            withAnimation: true
                        )
                    }.store(in: &subscriptions)
            })
    }
}

// MARK: - Private functions
extension InteractWithEntityDemo {

    private func makeRotation(with timeInterval: TimeInterval) -> Rotation3D {
        let degree = Double(Int(timeInterval) % 36 * 20)
        let angle = Angle2D(degrees: degree)
        return Rotation3D(angle: angle, axis: .xy)
    }
 }

#Preview {
    InteractWithEntityDemo()
}
