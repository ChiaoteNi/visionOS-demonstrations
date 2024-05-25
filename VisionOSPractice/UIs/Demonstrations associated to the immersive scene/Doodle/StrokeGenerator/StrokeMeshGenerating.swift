//
//  StrokeMeshGenerating.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/20.
//

import Foundation
import CoreGraphics

protocol StrokeGenerating {
    var strokeWidth: Double { get }

    func makeIndexes() -> [UInt32]
    func makeEdges(startPoint: TDPoint, endPoint: TDPoint, width: Double) -> [TDPoint]
    func makeStroke(startPoint: TDPoint, endPoint: TDPoint, color: CGColor, previousStroke: TDStroke?) -> TDStroke
}

extension StrokeGenerating {

    func makeStroke(
        startPoint: TDPoint,
        endPoint: TDPoint,
        color: CGColor,
        previousStroke: TDStroke?
    ) -> TDStroke {

        let edges = makeEdges(startPoint: startPoint, endPoint: endPoint, width: strokeWidth)
        var indexes = makeIndexes()

        guard let previousStroke else {
            return TDStroke(color: color, edges: edges, indexes: indexes)
        }
        let edgesCount = edges.count

        indexes = indexes.map { index in
            index + UInt32(previousStroke.edges.count) - UInt32(edgesCount/2)
        }
        let newEdges = edges.filterOutFirst(edgesCount/2)

        return TDStroke(
            color: color,
            edges: previousStroke.edges + newEdges,
            indexes: previousStroke.indexes + indexes
        )
    }
}
