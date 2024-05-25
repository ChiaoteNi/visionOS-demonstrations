//
//  RingStrokeGenerator.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/20.
//

import Foundation
import CoreGraphics

struct RingStrokeGenerator: StrokeGenerating {
    var strokeWidth: Double { 0.01 }
    var segments: Int { 8 } // Number of segments to approximate the ring

    func makeIndexes() -> [UInt32] {
        var indexes: [UInt32] = []

        for i in 0..<segments {
            let next = (i + 1) % segments
            let base1 = UInt32(i)
            let base2 = UInt32(i + segments)
            let top1 = UInt32(next)
            let top2 = UInt32(next + segments)

            indexes.append(contentsOf: [base1, top1, base2])
            indexes.append(contentsOf: [top1, top2, base2])
        }

        return indexes
    }

    func makeEdges(startPoint: TDPoint, endPoint: TDPoint, width: Double) -> [TDPoint] {
        var edges: [TDPoint] = []

        let vector = endPoint - startPoint
        let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let unitVector = vector / length

        // Create two perpendicular vectors
        let perpendicularVector1 = SIMD3<Double>(
            unitVector.y - unitVector.z,
            unitVector.z - unitVector.x,
            unitVector.x - unitVector.y
        ).normalized()

        let perpendicularVector2 = unitVector.cross(perpendicularVector1).normalized()

        for i in 0 ..< segments {
            let angle = (Double(i) / Double(segments)) * 2 * .pi
            let offset = perpendicularVector1 * cos(angle) * width + perpendicularVector2 * sin(angle) * width

            let startEdge = startPoint + offset
            let endEdge = endPoint + offset

            edges.append(startEdge)
            edges.append(endEdge)
        }

        return edges
    }

    private func length(_ vector: TDPoint) -> Double {
        sqrt(
            vector.x * vector.x
            + vector.y * vector.y
            + vector.z * vector.z
        )
    }
}

private extension SIMD3 where Scalar == Double {
    func normalized() -> SIMD3 {
        self / length()
    }

    func cross(_ other: SIMD3) -> SIMD3 {
        SIMD3(
            x: self.y * other.z - self.z * other.y,
            y: self.z * other.x - self.x * other.z,
            z: self.x * other.y - self.y * other.x
        )
    }

    func length() -> Double {
        sqrt(x * x + y * y + z * z)
    }
}
