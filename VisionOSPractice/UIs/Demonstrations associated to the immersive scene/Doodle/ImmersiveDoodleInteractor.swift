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

        if let currentLocation {
            let stroke = strokeGenerator.makeStroke(
                startPoint: currentLocation,
                endPoint: convertedLocation,
                color: currentColor,
                previousStroke: currentStroke
            )
            self.currentStroke = stroke

            Task {
                await stateStore?.updateStroke(stroke)
            }
        }
        currentLocation = convertedLocation
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
