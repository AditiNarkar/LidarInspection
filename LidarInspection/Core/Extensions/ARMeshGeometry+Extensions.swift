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

        precondition(index >= 0 && index < vertices.count)

        let pointer = vertices.buffer.contents()
            .advanced(by: vertices.offset + index * vertices.stride)

        return pointer.load(as: SIMD3<Float>.self)
    }
}
