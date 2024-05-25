//
//  BasicStrokeGenerator.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/20.
//

import Foundation
import CoreGraphics

struct BasicStrokeGenerator: StrokeGenerating {
    var strokeWidth: Double { 0.01 }

    func makeIndexes() -> [UInt32] {
        [
            0, 2, 6,
            6, 4, 0,
            2, 1, 5,
            5, 6, 1,
            1, 3, 7,
            7, 5, 1,
            3, 0, 4,
            4, 7, 3
        ]
    }

    func makeEdges(startPoint: TDPoint, endPoint: TDPoint, width: Double) -> [TDPoint] {
        // 1. calculate two vectors
        let vector = SIMD3(
            startPoint.x - endPoint.x,
            startPoint.y - endPoint.y,
            startPoint.z - endPoint.z
        )
        // 2. calculate the unit vector of the vector
        let unitVector = vector / length(vector)
        // 3. calculate two vectors that are vertical to the unitVector
        let verticalUnitVector1 = SIMD3(
            cos(90) * unitVector.x - sin(90) * unitVector.y,
            sin(90) * unitVector.x + cos(90) * unitVector.y,
            unitVector.z
        )
        let verticalUnitVector2 = SIMD3(
            cos(90) * unitVector.x - sin(90) * unitVector.z,
            unitVector.y,
            sin(90) * unitVector.x + cos(90) * unitVector.z
        )

        // 5. make four edges that near the startPoint
        let point1 = startPoint + verticalUnitVector1 * width
        let point2 = startPoint - verticalUnitVector1 * width
        let point3 = startPoint + verticalUnitVector2 * width
        let point4 = startPoint - verticalUnitVector2 * width

        // 6. make four edges that near the endPoint
        let point5 = endPoint + verticalUnitVector1 * width
        let point6 = endPoint - verticalUnitVector1 * width
        let point7 = endPoint + verticalUnitVector2 * width
        let point8 = endPoint - verticalUnitVector2 * width

        return [point1, point2, point3, point4, point5, point6, point7, point8]
    }

    private func length(_ vector: TDPoint) -> Double {
        sqrt(
            vector.x * vector.x
            + vector.y * vector.y
            + vector.z * vector.z
        )
    }
}


