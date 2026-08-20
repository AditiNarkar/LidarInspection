//
//  DimensionMeasurementService.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//


import ARKit
import simd

protocol DimensionMeasuring {

    func measure(
        anchors: [ARMeshAnchor],
        around center: SIMD3<Float>
    ) throws -> MeasuredDimensions
}

final class DimensionMeasurementService: DimensionMeasuring {

    func measure(
        anchors: [ARMeshAnchor],
        around center: SIMD3<Float>
    ) throws -> MeasuredDimensions {

        var points: [SIMD3<Float>] = []

        for anchor in anchors {

            let geometry = anchor.geometry

            let vertexCount =
                geometry.vertices.count

            for index in 0..<vertexCount {

                let vertex =
                    geometry.vertex(at: index)

                let worldPosition =
                    transformPoint(
                        vertex,
                        by: anchor.transform
                    )

                let distance =
                    worldPosition.distance(to: center)

                guard distance <=
                        AppConstants.Measurement.objectRadius
                else {
                    continue
                }

                points.append(worldPosition)
            }
        }

        guard points.count >=
                AppConstants.Measurement.minimumPointCount
        else {
            throw InspectionError.insufficientMeshData
        }

        return boundingBox(
            from: points
        )
    }

    private func transformPoint(
        _ point: SIMD3<Float>,
        by transform: simd_float4x4
    ) -> SIMD3<Float> {

        let homogeneous =
            SIMD4<Float>(
                point.x,
                point.y,
                point.z,
                1
            )

        let transformed =
            transform * homogeneous

        return SIMD3<Float>(
            transformed.x,
            transformed.y,
            transformed.z
        )
    }

    private func boundingBox(
        from points: [SIMD3<Float>]
    ) -> MeasuredDimensions {

        var minimum = points[0]
        var maximum = points[0]

        for point in points.dropFirst() {

            minimum = simd_min(
                minimum,
                point
            )

            maximum = simd_max(
                maximum,
                point
            )
        }

        let size =
            maximum - minimum

        return MeasuredDimensions(
            width: abs(size.x),
            breadth: abs(size.z),
            height: abs(size.y)
        )
    }
}
