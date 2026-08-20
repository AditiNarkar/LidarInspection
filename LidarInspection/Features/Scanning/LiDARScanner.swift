//
//  LiDARScanner.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import ARKit
import RealityKit
import simd

@MainActor
final class LiDARScanner: NSObject {

    private(set) var session: ARSession

    private var meshAnchors: [UUID: ARMeshAnchor] = [:]

    private(set) var isRunning = false

    override init() {

        self.session = ARSession()

        super.init()

        session.delegate = self
    }

    func start() throws {

        guard ARWorldTrackingConfiguration.isSupported else {
            throw InspectionError.lidarUnavailable
        }

        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            throw InspectionError.sceneReconstructionUnavailable
        }

        let configuration = makeConfiguration()

        session.run(
            configuration,
            options: [
                .resetTracking,
                .removeExistingAnchors
            ]
        )

        isRunning = true
    }

    func resume() throws {

        guard ARWorldTrackingConfiguration.isSupported,
              ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        else {
            throw InspectionError.lidarUnavailable
        }

        session.run(makeConfiguration())
        isRunning = true
    }

    func stop() {

        session.pause()

        isRunning = false
    }

    func reset() {

        meshAnchors.removeAll()

        guard isRunning else {
            return
        }

        session.pause()

        session.run(
            makeConfiguration(),
            options: [
                .resetTracking,
                .removeExistingAnchors
            ]
        )
    }

    func meshAnchorsSnapshot() -> [ARMeshAnchor] {

        Array(meshAnchors.values)
    }

    private func makeConfiguration() -> ARWorldTrackingConfiguration {

        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .mesh
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        return configuration
    }
}

extension LiDARScanner: ARSessionDelegate {

    nonisolated func session(
        _ session: ARSession,
        didAdd anchors: [ARAnchor]
    ) {

        Task { @MainActor in

            for anchor in anchors {

                guard let meshAnchor =
                        anchor as? ARMeshAnchor
                else {
                    continue
                }

                meshAnchors[meshAnchor.identifier] =
                    meshAnchor
            }
        }
    }

    nonisolated func session(
        _ session: ARSession,
        didUpdate anchors: [ARAnchor]
    ) {

        Task { @MainActor in

            for anchor in anchors {

                guard let meshAnchor =
                        anchor as? ARMeshAnchor
                else {
                    continue
                }

                meshAnchors[meshAnchor.identifier] =
                    meshAnchor
            }
        }
    }

    nonisolated func session(
        _ session: ARSession,
        didRemove anchors: [ARAnchor]
    ) {

        Task { @MainActor in

            for anchor in anchors {

                meshAnchors.removeValue(
                    forKey: anchor.identifier
                )
            }
        }
    }
}
