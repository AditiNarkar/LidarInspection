//
//  ResultsViewModel.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

@MainActor
final class ResultsViewModel:
    ObservableObject {

    let result: InspectionResult

    init(
        expected: ObjectDimensions,
        measured: MeasuredDimensions,
        tolerance: Tolerance =
            .defaultTolerance
    ) {

        let comparator =
        DimensionComparator()

        self.result =
            comparator.compare(
                expected: expected,
                measured: measured,
                tolerance: tolerance
            )
    }
}
