//
//  LidarInspectionApp.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import SwiftUI

@main
struct LidarInspectionApp: App {

    @State private var expectedDimensions:
        ObjectDimensions?

    @State private var measuredDimensions:
        MeasuredDimensions?

    private let scanner =
        LiDARScanner()

    var body: some Scene {

        WindowGroup {

            NavigationStack {

                if let expectedDimensions {

                    if let measuredDimensions {

                        ResultsView(
                            expected:
                                expectedDimensions,
                            measured:
                                measuredDimensions
                        )

                    } else {

                        ScanView(
                            expectedDimensions:
                                expectedDimensions,
                            scanner:
                                scanner
                        ) { measured in

                            measuredDimensions =
                                measured
                        }
                    }

                } else {

                    ConfigurationView {
                        dimensions in

                        expectedDimensions =
                            dimensions
                    }
                }
            }
        }
    }
}
