//
//  DimensionComparator.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

protocol DimensionComparing {
    func compare(
        expected: ObjectDimensions,
        measured: MeasuredDimensions,
        tolerance: Tolerance
    ) -> InspectionResult
}

final class DimensionComparator: DimensionComparing {

    func compare(
        expected: ObjectDimensions,
        measured: MeasuredDimensions,
        tolerance: Tolerance
    ) -> InspectionResult {

        let widthDeviation =
            measured.width - expected.width

        let breadthDeviation =
            measured.breadth - expected.breadth

        let heightDeviation =
            measured.height - expected.height

        let widthPass =
            abs(widthDeviation) <= tolerance.width

        let breadthPass =
            abs(breadthDeviation) <= tolerance.breadth

        let heightPass =
            abs(heightDeviation) <= tolerance.height

        let status: InspectionResult.Status =
            widthPass && breadthPass && heightPass
            ? .pass
            : .fail

        return InspectionResult(
            expected: expected,
            measured: measured,
            tolerance: tolerance,
            widthDeviation: widthDeviation,
            breadthDeviation: breadthDeviation,
            heightDeviation: heightDeviation,
            status: status
        )
    }
}
