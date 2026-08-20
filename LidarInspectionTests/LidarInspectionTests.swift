//
//  LidarInspectionTests.swift
//  LidarInspectionTests
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Testing
@testable import LidarInspection

struct LidarInspectionTests {

    @Test func comparisonPassesWithinTolerance() {
        let expected = ObjectDimensions(width: 0.100, breadth: 0.050, height: 0.025)
        let measured = MeasuredDimensions(width: 0.101, breadth: 0.049, height: 0.026)

        let result = DimensionComparator().compare(
            expected: expected,
            measured: measured,
            tolerance: .defaultTolerance
        )

        #expect(result.status == .pass)
        #expect(result.widthWithinTolerance)
        #expect(result.breadthWithinTolerance)
        #expect(result.heightWithinTolerance)
    }

    @Test func comparisonFailsWhenAnyDimensionExceedsTolerance() {
        let expected = ObjectDimensions(width: 0.100, breadth: 0.050, height: 0.025)
        let measured = MeasuredDimensions(width: 0.103, breadth: 0.050, height: 0.025)

        let result = DimensionComparator().compare(
            expected: expected,
            measured: measured,
            tolerance: .defaultTolerance
        )

        #expect(result.status == .fail)
        #expect(!result.widthWithinTolerance)
    }

}
