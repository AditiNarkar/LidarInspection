//
//  ARViewContainer.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {

    let scanner: LiDARScanner

    let onTap: (SIMD3<Float>) -> Void

    func makeUIView(
        context: Context
    ) -> ARView {

        let arView = ARView(
            frame: .zero
        )

        arView.session =
            scanner.session

        arView.environment
            .sceneUnderstanding
            .options
            .insert(.occlusion)

        let tapGesture =
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(
                    Coordinator.handleTap
                )
            )

        arView.addGestureRecognizer(
            tapGesture
        )

        context.coordinator.arView =
            arView

        return arView
    }

    func updateUIView(
        _ uiView: ARView,
        context: Context
    ) {
    }

    func makeCoordinator()
        -> Coordinator {

        Coordinator(
            onTap: onTap
        )
    }

    final class Coordinator: NSObject {

        weak var arView: ARView?

        private let onTap:
            (SIMD3<Float>) -> Void

        init(
            onTap: @escaping
                (SIMD3<Float>) -> Void
        ) {

            self.onTap = onTap
        }

        @objc
        func handleTap(
            _ gesture:
            UITapGestureRecognizer
        ) {

            guard let arView else {
                return
            }

            let location =
                gesture.location(
                    in: arView
                )

            guard let result =
                    arView.raycast(
                        from: location,
                        allowing: .estimatedPlane,
                        alignment: .any
                    ).first
            else {
                return
            }

            let transform =
                result.worldTransform

            let position =
                SIMD3<Float>(
                    transform.columns.3.x,
                    transform.columns.3.y,
                    transform.columns.3.z
                )

            onTap(position)
        }
    }
}
