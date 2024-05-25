//
//  ImmersiveDoodleDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2024/5/19.
//

import SwiftUI
import RealityKit

#if os(visionOS)
struct ImmersiveDoodleDemo: View {

    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var globalStateStore: GlobalStateStore

    var interactor: ImmersiveDoodleInteractor
    @StateObject var stateStore: ThreeDimensionCanvasStateStore

    @State var canvas: Entity?
    @State var canvasSize: Size3D = .one

    init() {
        let store = ThreeDimensionCanvasStateStore()
        let interactor = ImmersiveDoodleInteractor()

        self.interactor = interactor
        _stateStore = StateObject(wrappedValue: store)

        interactor.stateStore = store
    }

    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in
                // Create an empty entity as the canvas to receive spatial gesture events.
                let canvas = makeCanvasEntity()
                canvas.position = .zero
                content.add(canvas)
                self.canvas = canvas
            } update: { content in
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
            .gesture(drawGesture())
            .onAppear {
                canvasSize = proxy.frame(in: .immersiveSpace).size
                interactor.enableDrawingStrokes = true

                // To display the sidePanel window
                openWindow(id: "sidePanel", value: "colorPicker")

                // x-axis
                interactor.updateStrokeColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
                interactor.drawingChanged(TDPoint(x: 0, y: 0, z: 0))
                interactor.finishDrawing(TDPoint(x: 1, y: 0, z: 0))
                // y-axis
                interactor.updateStrokeColor(CGColor(red: 0, green: 1, blue: 0, alpha: 1))
                interactor.drawingChanged(TDPoint(x: 0, y: 0, z: 0))
                interactor.finishDrawing(TDPoint(x: 0, y: 1, z: 0))
                // z-axis
                interactor.updateStrokeColor(CGColor(red: 0, green: 0, blue: 1, alpha: 1))
                interactor.drawingChanged(TDPoint(x: 0, y: 0, z: 0))
                interactor.finishDrawing(TDPoint(x: 0, y: 0, z: 1))

                // reset the stroke color
                interactor.updateStrokeColor(globalStateStore.currentColor)
            }
            .onChange(of: globalStateStore.currentColor) {
                interactor.updateStrokeColor(globalStateStore.currentColor)
            }
        }
    }
}

// MARK: - Private functions
extension ImmersiveDoodleDemo {

    // MARK: Entity creation

    private func makeCanvasEntity() -> Entity {
        let canvas = Entity()
        // Set up inputTarget and collisions to make the entity interactive and able to receive gesture events.
        // indirect: All forms of input that target content using an indirect targeting mechanism.
        canvas.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        canvas.components.set(
            CollisionComponent(
                shapes: [ShapeResource.generateSphere(radius: 5)],
                isStatic: true
            )
        )
        // I simplified the implementation of canvas entity, inspired by Hattori Satoshi's visionOS_30Days,
        // which is much simpler than my previous canvas implementation in ThreeDimensionCanvasDemo.swift
        // The reference is here: https://github.com/satoshi0212/visionOS_30Days/blob/main/Day13/Day13/ViewModel.swift
        return canvas
    }

    private func makePointEntity(with location: SIMD3<Double>) -> some Entity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.1, cornerRadius: 0.05),
            materials: [
                SimpleMaterial(
                    color: UIColor(cgColor: globalStateStore.currentColor),
                    isMetallic: false
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
                SimpleMaterial(color: UIColor(cgColor: stroke.color), isMetallic: false)
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
        SpatialEventGesture(coordinateSpace: .immersiveSpace)
        // Detecting the drawing gesture by observing the user's fingers using the ARKitSession is the best practice.
        // However, since the simulator does not support mock finger detection,
        // I created a 5-meters sphere canvas and used the indirect method to detect gestures inside it.
        // This method is only able to detect gesture changes and user's position changes, but it cannot detect the change of star points.
            .handActivationBehavior(.pinch)
            .onChanged { collection in
                collection.forEach { event in
                    guard let inputDevicePose = event.inputDevicePose else {
                        return
                    }
                    let point = makeTDPoint(
                        eventLocation: event.location3D,
                        inputDevicePose: inputDevicePose
                    )
                    interactor.drawingChanged(point)
                }
            }
            .onEnded { collection in
                collection.forEach { event in
                    guard let inputDevicePose = event.inputDevicePose else {
                        return
                    }
                    let point = makeTDPoint(
                        eventLocation: event.location3D,
                        inputDevicePose: inputDevicePose
                    )
                    interactor.finishDrawing(point)
                }
            }
    }

    private func makeTDPoint(
        eventLocation: Point3D,
        inputDevicePose: SpatialEventCollection.Event.InputDevicePose
    ) -> TDPoint {

        let origin = SIMD3(
            Double(eventLocation.x) / canvasSize.width,
            Double(eventLocation.y) / canvasSize.height,
            Double(eventLocation.z) / canvasSize.depth
        )
        // InputDevicePose: A pose describing the input device, like a hand controlling the event. It's not the position of the headset
        let pose3D = inputDevicePose.pose3D
        let location = SIMD3(
            pose3D.matrix.columns.2.x,
            pose3D.matrix.columns.2.y,
            pose3D.matrix.columns.2.z
        )
        return TDPoint(
            Double(origin.x + location.x),
            Double(origin.y + location.y),
            Double(origin.z + location.z)
        )
    }
}

#Preview {
    ImmersiveDoodleDemo()
}
#endif
