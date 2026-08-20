//
//  SIMD3+Extensions.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import simd

extension SIMD3<Float> {

    var magnitude: Float {
        simd_length(self)
    }

    func distance(to other: SIMD3<Float>) -> Float {
        simd_distance(self, other)
    }
}
