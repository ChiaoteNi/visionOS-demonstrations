//
//  ThreeDimensionCanvasInteractor.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/21.
//

import Foundation
import CoreGraphics

typealias TDPoint = SIMD3<Double>

final class TDStroke: Identifiable {
    let id: String
    let color: CGColor
    var edges: [TDPoint]
    var indexes: [UInt32]

    init(id: String = UUID().uuidString, color: CGColor, edges: [TDPoint], indexes: [UInt32]) {
        self.id = id
        self.color = color
        self.edges = edges
        self.indexes = indexes
    }
}

protocol ThreeDimensionStateStoring: AnyObject {
    func updatePoint(with point: TDPoint) async
    func updateStroke(_ stroke: TDStroke) async
    func finishStroke(_ stroke: TDStroke) async
}

final class ThreeDimensionCanvasInteractor {

    weak var stateStore: ThreeDimensionStateStoring?

    var enableDrawingStrokes: Bool = false

    private var canvasSize: SIMD3<Double> = .zero

    private var currentColor: CGColor = CGColor(gray: 0, alpha: 0)
    private var currentLocation: TDPoint?
    private var currentStroke: TDStroke?

    func updateCanvasSize(_ canvasSize: SIMD3<Double>) {
        self.canvasSize = canvasSize
    }

    func updateStrokeColor(_ color: CGColor) {
        self.currentColor = color
    }

    func drawingChanged(_ location: TDPoint) {
        let normalizedLocation = convertGestureLocationToEntityLocation(location)
        Task {
            await stateStore?.updatePoint(with: normalizedLocation)
        }

        guard enableDrawingStrokes else { return }

        if let currentLocation {
            let edges = makeEdges(startPoint: currentLocation, endPoint: normalizedLocation, width: 0.01)
            let indexes = makeIndexes()
            let stroke = makeStroke(
                with: indexes,
                edges: edges,
                color: currentColor,
                previousStroke: currentStroke
            )

            self.currentStroke = stroke
            Task {
                await stateStore?.updateStroke(stroke)
            }
        }
        currentLocation = normalizedLocation
    }

    func finishDrawing(_ location: TDPoint) {
        let normalizedLocation = convertGestureLocationToEntityLocation(location)
        Task {
            await stateStore?.updatePoint(with: normalizedLocation)
        }

        guard enableDrawingStrokes else {
            return
        }
        guard let currentLocation else {
            assertionFailure("Exception: currentLocation not exist")
            return
        }

        let edges = makeEdges(startPoint: currentLocation, endPoint: normalizedLocation, width: 0.01)
        let indexes = makeIndexes()
        let stroke = makeStroke(
            with: indexes,
            edges: edges,
            color: currentColor,
            previousStroke: currentStroke
        )

        self.currentStroke = nil
        self.currentLocation = nil

        Task {
            await stateStore?.finishStroke(stroke)
        }
    }
}

extension ThreeDimensionCanvasInteractor {

    private func makeStroke(
        with indexes: [UInt32],
        edges: [TDPoint],
        color: CGColor,
        previousStroke: TDStroke?
    ) -> TDStroke {
        guard let previousStroke else {
            return TDStroke(color: color, edges: edges, indexes: indexes)
        }

        let edgesCount = edges.count

        let indexes = indexes.map { index in
            index + UInt32(previousStroke.edges.count) - UInt32(edgesCount/2)
        }
        let newEdges = edges.filterOutFirst(edgesCount/2)

        return TDStroke(
            color: color,
            edges: previousStroke.edges + newEdges,
            indexes: previousStroke.indexes + indexes
        )
    }

    private func makeIndexes() -> [UInt32] {
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

    private func makeEdges(startPoint: TDPoint, endPoint: TDPoint, width: Double) -> [TDPoint] {
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
        return sqrt(
            vector.x * vector.x
            + vector.y * vector.y
            + vector.z * vector.z
        )
    }

    private func convertGestureLocationToEntityLocation(_ gestureLocation: TDPoint) -> TDPoint {
        // For more details, please refer to [here](https://www.wwdcnotes.com/images/notes/wwdc23/10080/coordinate-conventions.png)
        let normalizedLocation = TDPoint(
            x: gestureLocation.x / canvasSize.x - 0.5,
            y: -(gestureLocation.y / canvasSize.y - 0.5),
            z: gestureLocation.z / canvasSize.z - 0.5
        )
        return normalizedLocation
    }
}
