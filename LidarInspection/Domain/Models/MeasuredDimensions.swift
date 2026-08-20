//
//  MeasuredDimensions.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

struct MeasuredDimensions: Equatable, Sendable {

    let width: Float
    let breadth: Float
    let height: Float

    var volume: Float {
        width * breadth * height
    }
}
