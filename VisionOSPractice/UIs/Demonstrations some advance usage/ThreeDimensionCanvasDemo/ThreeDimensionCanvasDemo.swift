//
//  ThreeDimensionCanvasDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/21.
//

import SwiftUI
import RealityKit

#if os(visionOS)
struct ThreeDimensionCanvasDemo: View {

    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var globalStateStore: GlobalStateStore

    var interactor: ThreeDimensionCanvasInteractor
    @StateObject var stateStore: ThreeDimensionCanvasStateStore

    init() {
        let store = ThreeDimensionCanvasStateStore()
        let interactor = ThreeDimensionCanvasInteractor()

        self.interactor = interactor
        _stateStore = StateObject(wrappedValue: store)

        interactor.stateStore = store
    }

    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in
                // In this demonstration, I create an empty entity as the canvas to receive spatial gesture events.
                // This is because, until now, we're not able to detect spatial hands in the Xcode 15.1 simulator.
                // However, this isn't the required implementation for drawing in a spatial space.
                // Instead, it's just a workaround for now to receive spatial gesture events from the RealityView
                // and serves as a simple demonstration of how to create an entity without a USDZ file.
                let canvas = makeCanvasEntity()
                canvas.position = .zero
                content.add(canvas)
            } update: { content in
//                // Case 1: Add a sphere to the gesture event's coordinates
//                if let point = stateStore.currentPT {
//                    let entity = makePointEntity(with: point)
//                    content.add(entity)
//                }

                // Case 2: add strokes to the RealityView with the gesture event's coordinates
                if let stroke = stateStore.currentStroke {
                    if let entity = content.entities.first(where: { $0.name == stroke.id }),
                       let modelEntity = entity as? ModelEntity {
                        do {
                            let meshDescriptor = makeMeshDescriptor(with: stroke)
                            let meshResource = try MeshResource.generate(from: [meshDescriptor])
                            try modelEntity.model?.mesh.replace(with: meshResource.contents)
                        } catch {
                            assertionFailure(error.localizedDescription)
                        }
                    } else if let result = makeStrokeEntity(with: stroke) {
                        content.add(result)
                    }
                }
                stateStore.strokes.forEach { stroke in
                    if content.entities.first(where: { $0.name == stroke.id }) == nil,
                       let entity = makeStrokeEntity(with: stroke){
                        content.add(entity)
                    }
                }
            }
            .clipped(antialiased: false)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .gesture(drawGesture())
            .onAppear {
                interactor.updateStrokeColor(globalStateStore.currentColor)
                interactor.updateCanvasSize(SIMD3<Double>(
                    x: proxy.size.width,
                    y: proxy.size.height,
                    z: proxy.size.depth
                ))
                interactor.enableDrawingStrokes = true

                // To display the sidePanel window
                openWindow(id: "sidePanel", value: "colorPicker")

                // The following code is for demonstrating how stroke generation works with the location from gesture events.
                let denormalized: (_ pt: SIMD3<Double>) -> SIMD3<Double> = { pt in
                    TDPoint(
                        x: pt.x * Double(proxy.size.width),
                        y: pt.y * Double(proxy.size.height),
                        z: pt.z * Double(proxy.size.depth)
                    )
                }
                interactor.drawingChanged(denormalized(.init(x: 0.1, y: 0.5, z: 0.5)))
                interactor.drawingChanged(denormalized(.init(x: 0.9, y: 0.5, z: 0.5)))
                interactor.drawingChanged(denormalized(.init(x: 0.9, y: 0.2, z: 0.5)))
                interactor.finishDrawing(denormalized(.init(x: 0.1, y: 0.2, z: 0.5)))
                interactor.drawingChanged(denormalized(.init(x: 0.1, y: 0.7, z: 0.5)))
                interactor.finishDrawing(denormalized(.init(x: 0.9, y: 0.7, z: 0.5)))
            }
            .onChange(of: globalStateStore.currentColor) {
                interactor.updateStrokeColor(globalStateStore.currentColor)
            }
        }
    }
}

// MARK: - Private functions
extension ThreeDimensionCanvasDemo {

    // MARK: Entity creation

    private func makeCanvasEntity() -> some Entity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.9, cornerRadius: 0),
            materials: [
                SimpleMaterial(
                    color: .init(white: 1, alpha: 0.1),
                    isMetallic: true
                )
            ],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
            mass: 0
        )
        entity.components.set(InputTargetComponent(allowedInputTypes: .all))
        return entity
    }

    private func makePointEntity(with location: SIMD3<Double>) -> some Entity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.01, cornerRadius: 0.005),
            materials: [
                SimpleMaterial(
                    color: UIColor(cgColor: globalStateStore.currentColor),
                    isMetallic: true
                )
            ],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0)),
            mass: 0
        )
        entity.position = SIMD3(x: Float(location.x), y: Float(location.y), z: Float(location.z))
        return entity
    }

    private func makeStrokeEntity(with stroke: TDStroke) -> ModelEntity? {
        var meshDescriptor = makeMeshDescriptor(with: stroke)
        meshDescriptor.materials = .allFaces(0)
        do {
            let meshResource = try MeshResource.generate(from: [meshDescriptor])
            let materials = [
                // The SimpleMaterial should be initialized from a main thread context
                SimpleMaterial(color: UIColor(cgColor: stroke.color), isMetallic: true)
            ]
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

    private func makeMeshDescriptor(with stroke: TDStroke) -> MeshDescriptor {
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.primitives = .triangles(stroke.indexes)
        meshDescriptor.name = stroke.id
        let positions = stroke.edges.map { edge in
            SIMD3<Float>(
                x: Float(edge.x),
                y: Float(edge.y),
                z: Float(edge.z)
            )
        }
        meshDescriptor.positions = .init(positions)
        return meshDescriptor
    }

    // MARK: Gesture

    private func drawGesture() -> some Gesture {
        SpatialEventGesture(coordinateSpace: .local)
            .targetedToAnyEntity()
            .onChanged { collection in
                collection.gestureValue.forEach { event in
                    interactor.drawingChanged(TDPoint(
                        x: event.location3D.x,
                        y: event.location3D.y,
                        z: event.location3D.z
                    ))
                }
            }
            .onEnded { collection in
                collection.gestureValue.forEach { event in
                    interactor.finishDrawing(TDPoint(
                        x: event.location3D.x,
                        y: event.location3D.y,
                        z: event.location3D.z
                    ))
                }
            }
    }
}

#Preview {
    ThreeDimensionCanvasDemo()
}
#endif
