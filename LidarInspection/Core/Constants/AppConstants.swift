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

        // Depth tolerance used during object isolation.
        static let depthTolerance: Float = 0.15
    }

    enum UI {

        static let minimumDimension: Float = 0.001

        static let maximumDimension: Float = 10.0
    }
}
