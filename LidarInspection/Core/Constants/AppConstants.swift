//
//  AppConstants.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

enum AppConstants {

    enum Measurement {

        // Minimum number of mesh vertices required
        // before attempting dimensional estimation.
        static let minimumPointCount = 30

        // Maximum distance from the selected object
        // center to consider a mesh point.
        static let objectRadius: Float = 0.75

        // Vertical bin size used to identify the horizontal surface supporting
        // the part (for example, a bench or floor).
        static let supportSurfaceBinSize: Float = 0.008

        // Mesh points this close to the support surface are treated as part of
        // the bench/floor and excluded from the object's footprint.
        static let supportSurfaceClearance: Float = 0.012

        // A support surface must span at least this distance in both horizontal
        // axes before it is removed. This avoids mistaking a small object face
        // for the bench.
        static let minimumSupportSurfaceSpan: Float = 0.10
    }

    enum UI {

        static let minimumDimension: Float = 0.001

        static let maximumDimension: Float = 10.0
    }
}
