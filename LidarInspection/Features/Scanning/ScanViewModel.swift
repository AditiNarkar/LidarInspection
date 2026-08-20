//
//  ScanViewModel.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation
import simd

@MainActor
final class ScanViewModel:
    ObservableObject {

    @Published private(set) var isScanning =
        false

    @Published private(set) var selectedPoint:
        SIMD3<Float>?

    @Published private(set) var measuredDimensions:
        MeasuredDimensions?

    @Published var errorMessage:
        String?

    let scanner: LiDARScanner

    private let measurementService:
        DimensionMeasuring

    init(
        scanner: LiDARScanner,
        measurementService:
            DimensionMeasuring =
            DimensionMeasurementService()
    ) {

        self.scanner = scanner

        self.measurementService =
            measurementService
    }

    func start() {

        do {

            try scanner.start()

            isScanning = true

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }

    func stop() {

        scanner.stop()

        isScanning = false
    }

    func selectObject(
        at point: SIMD3<Float>
    ) {

        selectedPoint = point
        measuredDimensions = nil
    }

    func measureObject() {

        guard let selectedPoint else {

            errorMessage =
                "Tap the object first."

            return
        }

        do {

            measuredDimensions =
                try measurementService.measure(
                    anchors:
                        scanner.meshAnchorsSnapshot(),
                    around:
                        selectedPoint
                )

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }

    func reset() {

        scanner.reset()

        selectedPoint = nil

        measuredDimensions = nil

        errorMessage = nil
    }
}
