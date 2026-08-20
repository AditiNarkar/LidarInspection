//
//  ARMeshGeometry+Extensions.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import ARKit
import simd

extension ARMeshGeometry {

    func vertex(
        at index: Int
    ) -> SIMD3<Float> {

        let pointer =
            vertices.buffer.contents()

        let typedPointer =
            pointer.assumingMemoryBound(
                to: SIMD3<Float>.self
            )

        return typedPointer[index]
    }
}
