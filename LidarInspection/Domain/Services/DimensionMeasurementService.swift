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

        let supportSurface = supportSurfaceHeight(
            in: points,
            below: center
        )

        let objectPoints: [SIMD3<Float>]
        if let supportSurface {
            objectPoints = points.filter {
                $0.y > supportSurface + AppConstants.Measurement.supportSurfaceClearance
            }
        } else {
            objectPoints = points
        }

        guard objectPoints.count >= AppConstants.Measurement.minimumPointCount else {
            throw InspectionError.insufficientMeshData
        }

        return boundingBox(
            from: objectPoints,
            supportSurface: supportSurface
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

    private func supportSurfaceHeight(
        in points: [SIMD3<Float>],
        below selectedPoint: SIMD3<Float>
    ) -> Float? {

        let binSize = AppConstants.Measurement.supportSurfaceBinSize
        let candidatePoints = points.filter {
            $0.y <= selectedPoint.y + binSize * 2
        }

        var bins: [Int: [SIMD3<Float>]] = [:]
        for point in candidatePoints {
            let bin = Int((point.y / binSize).rounded())
            bins[bin, default: []].append(point)
        }

        let requiredSpan = AppConstants.Measurement.minimumSupportSurfaceSpan
        let surfaceBins = bins.values.filter { points in
            guard points.count >= AppConstants.Measurement.minimumPointCount else {
                return false
            }

            let xValues = points.map(\.x)
            let zValues = points.map(\.z)
            guard let minX = xValues.min(), let maxX = xValues.max(),
                  let minZ = zValues.min(), let maxZ = zValues.max()
            else {
                return false
            }

            return maxX - minX >= requiredSpan && maxZ - minZ >= requiredSpan
        }

        // Prefer the largest horizontal footprint: the support surface contains
        // substantially more local mesh points than an individual part face.
        return surfaceBins.max(by: { $0.count < $1.count })
            .map { $0.reduce(0) { $0 + $1.y } / Float($0.count) }
    }

    private func boundingBox(
        from points: [SIMD3<Float>],
        supportSurface: Float?
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

        let size = maximum - minimum
        let height = supportSurface.map { maximum.y - $0 } ?? abs(size.y)

        return MeasuredDimensions(
            width: abs(size.x),
            breadth: abs(size.z),
            height: height
        )
    }
}
