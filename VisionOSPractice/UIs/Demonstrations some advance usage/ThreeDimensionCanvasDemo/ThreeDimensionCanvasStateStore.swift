//
//  ThreeDimensionCanvasStateStore.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/21.
//

import Foundation
import SwiftUI

@MainActor
final class ThreeDimensionCanvasStateStore: ThreeDimensionStateStoring, ObservableObject {

    @Published var strokes: [TDStroke] = []

    @Published
    var currentStroke: TDStroke?

    @Published
    var currentPT: TDPoint?

    func updatePoint(with point: TDPoint) async {
        currentPT = point
    }

    func updateStroke(_ stroke: TDStroke) async {
        currentStroke = TDStroke(
            id: String(strokes.count),
            color: stroke.color,
            edges: stroke.edges,
            indexes: stroke.indexes
        )
    }

    func finishStroke(_ stroke: TDStroke) async {
        await updateStroke(stroke)

        guard let stroke = currentStroke else { return }
        strokes.append(stroke)
        currentStroke = nil
    }
}
