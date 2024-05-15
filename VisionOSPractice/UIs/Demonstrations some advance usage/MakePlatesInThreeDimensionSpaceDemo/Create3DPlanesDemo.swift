//
//  Create3DPlanesDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/23.
//

import SwiftUI
import RealityKit

#if os(visionOS)
struct Create3DPlanesDemo: View {
    var body: some View {
        RealityView { content in
//            // Case 1: Basic - triangle
//            if let entity = await makeTriangleEntity() {
//                content.add(entity)
//            }

            // Case 2: Advanced - How to make various shapes?
            if let entity = await makeRectangleEntity() {
                content.add(entity)
            }
        } update: { content in

        }
    }
}

// MARK: - Private functions
extension Create3DPlanesDemo {

    @MainActor
    private func makeTriangleEntity() async -> ModelEntity? {
        let p0 = SIMD3<Float>(x: 0, y: 0, z: 0)
        let p1 = SIMD3<Float>(x: 1, y: 0, z: 0)
        let p2 = SIMD3<Float>(x: 1, y: 1, z: 0)

        // All edges for the triangle plate unit that we need the RealityKit to draw for us.
        let positions: [SIMD3<Float>] = [p0, p1, p2]

        // The ordering of the points that we want to draw triangle units.
        // Case 1: Front
        let indexes: [UInt32] = [
            0, 1, 2 // front
        ]
//        // Case 2: Back
//        let indexes: [UInt32] = [
//            0, 2, 1 // back
//        ]

        var meshDescriptor = MeshDescriptor()
        meshDescriptor.positions = MeshBuffers.Positions(positions)
        meshDescriptor.primitives = .triangles(indexes)
        meshDescriptor.materials = .allFaces(0)

        return makeEntity(with: meshDescriptor, colors: [.red])
    }

    @MainActor
    private func makeRectangleEntity() async -> ModelEntity? {
        let p0 = SIMD3<Float>(x: 0, y: 0, z: 0)
        let p1 = SIMD3<Float>(x: 1, y: 0, z: 0)
        let p2 = SIMD3<Float>(x: 1, y: 1, z: 0)
        let p3 = SIMD3<Float>(x: 0, y: 1, z: 0)

        let positions: [SIMD3<Float>] = [p0, p1, p2, p3]
        let indexes: [UInt32] = [
            0, 1, 2,
            3, 0, 1
        ]
        /*
         For more details, please refer to here:
         [Spiral Point](https://developer.apple.com/videos/play/wwdc2021/10075/?time=1558)
         */

        var meshDescriptor = MeshDescriptor()
        meshDescriptor.positions = MeshBuffers.Positions(positions)
        meshDescriptor.primitives = .triangles(indexes)
        meshDescriptor.materials = .perFace([0, 1])

        return makeEntity(with: meshDescriptor, colors: [.orange, .purple])
    }


    private func makeEntity(with meshDescriptor: MeshDescriptor, colors: [UIColor]) -> ModelEntity? {
        do {
            let meshResource = try MeshResource.generate(from: [meshDescriptor])
            let materials = colors.map {
                // The SimpleMaterial should be initialized from a main thread context
                SimpleMaterial(color: $0, isMetallic: true)
            }
            let result = ModelEntity(
                mesh: meshResource,
                materials: materials
            )
            return result
        } catch {
            print("Failed to generate mesh resource: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    Create3DPlanesDemo()
}
#endif
