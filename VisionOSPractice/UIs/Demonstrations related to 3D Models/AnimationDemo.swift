//
//  AnimationDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/8/15.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct AnimationDemo: View {

    @State
    private var currentDate = Date.now
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        RealityView { content in
            guard let toyBiplane = try? await Entity(named: "Telescope", in: realityKitContentBundle) else {
                return
            }
            content.add(toyBiplane)
        }
        .onReceive(timer, perform: { date in
            currentDate = date
        })
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded({ value in

                    let rotation = makeRotation(with: currentDate.timeIntervalSince1970)
                    let entity = value.entity

//                    // Case 1: without animation
//                    entity.transform.rotation = rotation

                    // Case 2: with animation
                    let end = Transform(
                        scale: entity.transform.scale,
                        rotation: rotation,
                        translation: entity.transform.translation
                    )
                    do {
                        let transformAnimation = FromToByAnimation(
                            name: "transform",
                            from: entity.transform,
                            to: end,
                            duration: 2,
                            timing: .easeInOut,
                            isAdditive: false,
                            bindTarget: .transform
                        )
                        let resource = try AnimationResource.generate(with: transformAnimation)
                        entity.playAnimation(resource)
                    } catch {
                        print(error)
                    }
                })
        )
    }

    private func makeRotation(with timeInterval: TimeInterval) -> simd_quatf {
        let degree = Double(Int(timeInterval) % 36 * 20)
        let angle = Angle2D(degrees: degree)
        let rotation = Rotation3D(angle: angle, axis: .xy)
        return simd_quatf(vector: simd_float4(rotation.vector))
    }
}

#Preview {
    AnimationDemo()
}
