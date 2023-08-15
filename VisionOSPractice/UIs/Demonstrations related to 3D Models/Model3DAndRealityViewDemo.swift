//
//  Model3DAndRealityViewDemo.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/8/14.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct Model3DAndRealityViewDemo: View {
    var body: some View {

        /*
         Model3D:
         - Starts from Z axis = 0
         - Resizable
         - Does not have the capacity to load sub-entities and perform detailed controlation
         - Load a 3D model as a view
         */
        Model3D(
            named: "ToyBiplane",
//            named: "MovingItem",
            bundle: realityKitContentBundle // from RealityKitContent
        ) { model in
            model
//                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }

        /*
         RealityView:
         - Center of Z-axis = 0
         - More complex for loading entities
         - Can load sub-entities and provide detailed control
         - Load a 3D model as a view
         */
        RealityView { content in
            if let scene = try? await Entity(
                named: "ToyBiplane",
//                named: "MovingItem",
                in: realityKitContentBundle
            ) {
                content.add(scene)
            }
        }
        .scaledToFit()
    }
}

#Preview {
    // Remember to rotate the view and look from the side;
    // you'll then notice the difference in z-offset between Model3D and RealityView.
    VStack {
        Model3DAndRealityViewDemo()
    }.glassBackgroundEffect()
}

#Preview {
    // This preview demonstrates a potential usage for Model3D
    HStack {
        VStack {
            Text("Title")
                .font(.title)
            Spacer()
                .frame(height: 30)
            Text("Some introductions \n blahblahblah")
                .font(.caption)
        }

        Spacer()
            .frame(width: 100, height: 0, alignment: .bottom)
        Model3D(
            named: "ToyBiplane",
            //            named: "MovingItem",
            bundle: realityKitContentBundle
        ) { model in
            model.scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
    .frame(width: 600, height: 300, alignment: .center)
    .glassBackgroundEffect()
}
