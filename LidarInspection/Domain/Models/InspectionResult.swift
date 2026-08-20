//
//  InspectionResult.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

struct InspectionResult: Equatable, Sendable {

    enum Status: String, Sendable {
        case pass = "PASS"
        case fail = "FAIL"
    }

    let expected: ObjectDimensions
    let measured: MeasuredDimensions
    let tolerance: Tolerance

    let widthDeviation: Float
    let breadthDeviation: Float
    let heightDeviation: Float

    let status: Status

    var widthWithinTolerance: Bool {
        abs(widthDeviation) <= tolerance.width
    }

    var breadthWithinTolerance: Bool {
        abs(breadthDeviation) <= tolerance.breadth
    }

    var heightWithinTolerance: Bool {
        abs(heightDeviation) <= tolerance.height
    }
}
