//
//  ImmersiveDoodleInteractor.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/19.
//

import Foundation
import CoreGraphics

final class ImmersiveDoodleInteractor {

    weak var stateStore: ThreeDimensionStateStoring?

    var enableDrawingStrokes: Bool = false

    private var canvasSize: SIMD3<Double> = SIMD3(1, 1, 1)

    private var currentColor: CGColor = CGColor(gray: 0, alpha: 0)
    private var currentLocation: TDPoint?
    private var currentStroke: TDStroke?

    private var strokeGenerator: StrokeGenerating

    init(
//        strokeGenerator: StrokeGenerating = BasicStrokeGenerator()
//        strokeGenerator: StrokeGenerating = CylinderStrokeGenerator()
        strokeGenerator: StrokeGenerating = RingStrokeGenerator()
    ) {
        self.strokeGenerator = strokeGenerator
    }

    func updateStrokeColor(_ color: CGColor) {
        self.currentColor = color
    }

    func drawingChanged(_ location: TDPoint) {
        let convertedLocation = convertGestureLocationToEntityLocation(location)
        Task {
            await stateStore?.updatePoint(with: convertedLocation)
        }
        guard enableDrawingStrokes else { return }

        guard let currentLocation else {
            currentLocation = convertedLocation
            return
        }
        guard convertedLocation.distance(to: currentLocation) >= 0.01 else {
            return
        }

        let stroke = strokeGenerator.makeStroke(
            startPoint: currentLocation,
            endPoint: convertedLocation,
            color: currentColor,
            previousStroke: currentStroke
        )
        self.currentStroke = stroke
        self.currentLocation = convertedLocation

        Task {
            await stateStore?.updateStroke(stroke)
        }
    }

    func finishDrawing(_ location: TDPoint) {
        let convertedLocation = convertGestureLocationToEntityLocation(location)
        Task {
            await stateStore?.updatePoint(with: convertedLocation)
        }

        guard enableDrawingStrokes else {
            return
        }
        guard let currentLocation else {
            assertionFailure("Exception: currentLocation not exist")
            return
        }
        let stroke = strokeGenerator.makeStroke(
            startPoint: currentLocation,
            endPoint: convertedLocation,
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

extension ImmersiveDoodleInteractor {

    private func convertGestureLocationToEntityLocation(_ gestureLocation: TDPoint) -> TDPoint {
        // For more details, please refer to [here](https://www.wwdcnotes.com/images/notes/wwdc23/10080/coordinate-conventions.png)
        let normalizedLocation = TDPoint(
            x: gestureLocation.x / canvasSize.x,
            y: -gestureLocation.y / canvasSize.y,
            z: gestureLocation.z / canvasSize.z
        )
        return normalizedLocation
    }
}

private extension SIMD3<Double> {

    func difference(to other: SIMD3<Double>) -> SIMD3<Double> {
        SIMD3(
            x: other.x - x,
            y: other.y - y,
            z: other.z - z
        )
    }

    func distance(to other: SIMD3<Double>) -> Double {
        let difference = self.difference(to: other)
        let x: Double = difference.x * difference.x
        let y: Double = difference.y * difference.y
        let z: Double = difference.z * difference.z
        return sqrt(x + y + z)
    }
}
