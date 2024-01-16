//
//  ImmersiveView.swift
//  BearBalloon
//
//  Created by Raymond Chen on 1/16/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            let floor = ModelEntity(mesh: .generatePlane(width: 20, depth: 20), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                PhysicsBodyComponent(massProperties: .default, mode: .static)
            )
            content.add(floor)
            
            let ceiling = ModelEntity(mesh: .generatePlane(width: 20, depth: 20), materials: [OcclusionMaterial()])
            ceiling.generateCollisionShapes(recursive: false)
            ceiling.position.y = 3
            ceiling.components[PhysicsBodyComponent.self] = .init(
                PhysicsBodyComponent(massProperties: .default,
                                     mode: .static)
            )
            content.add(ceiling)
            
            if let balloonModel = try? await Entity(named: "Bear_On_Balloons"),
               let balloon = balloonModel.children.first?.children.first,
               let environment = try? await EnvironmentResource(named: "studio") {
                balloon.scale = [0.2, 0.2, 0.2]
                balloon.position.y = 1
                balloon.position.z = -3
                
                balloon.components.set(ImageBasedLightComponent(source: .single(environment)))
                balloon.components.set(ImageBasedLightReceiverComponent(imageBasedLight: balloon))
                balloon.components.set(GroundingShadowComponent(castsShadow: true))
                
                balloon.components[CollisionComponent.self] = .init(shapes: [ShapeResource.generateSphere(radius: 0.8)])
                balloon.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.15),
                    mode: .dynamic)
                )
                
                balloon.components.set(InputTargetComponent())
                
                
                balloon.components.set(PhysicsSimulationComponent())
                balloon.components[PhysicsSimulationComponent.self]?.gravity = SIMD3(x: 0, y: 0.1, z: 0)
                
                content.add(balloon)
            }
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
            .onEnded { value in
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
            }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
