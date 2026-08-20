//
//  ScanView.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import SwiftUI

struct ScanView: View {

    @StateObject private var viewModel:
        ScanViewModel

    let expectedDimensions:
        ObjectDimensions

    let onComplete:
        (MeasuredDimensions) -> Void

    init(
        expectedDimensions:
            ObjectDimensions,
        scanner: LiDARScanner,
        onComplete:
            @escaping
            (MeasuredDimensions) -> Void
    ) {

        self.expectedDimensions =
            expectedDimensions

        self.onComplete =
            onComplete

        _viewModel =
            StateObject(
                wrappedValue:
                    ScanViewModel(
                        scanner: scanner
                    )
            )
    }

    var body: some View {

        ZStack {

            ARViewContainer(
                scanner:
                    viewModelScanner
            ) { point in

                viewModel.selectObject(
                    at: point
                )
            }
            .ignoresSafeArea()

            VStack {

                instructionView

                Spacer()

                controls
            }
            .padding()
        }
        .onAppear {

            viewModel.start()
        }
        .onDisappear {

            viewModel.stop()
        }
        .alert(
            "Scanning Error",
            isPresented:
                Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: { value in

                        if !value {
                            viewModel.errorMessage =
                                nil
                        }
                    }
                )
        ) {

            Button("OK") {
                viewModel.errorMessage =
                    nil
            }

        } message: {

            Text(
                viewModel.errorMessage ?? ""
            )
        }
    }

    private var viewModelScanner:
        LiDARScanner {

        Mirror(reflecting: viewModel)
            .children
            .first {
                $0.label == "scanner"
            }?
            .value as? LiDARScanner
            ?? LiDARScanner()
    }

    private var instructionView:
        some View {

        VStack(spacing: 8) {

            Text(
                "Position the object in front of the iPad"
            )
            .font(.headline)

            Text(
                "Move slowly around the object to allow LiDAR to capture its geometry."
            )
            .font(.subheadline)
            .multilineTextAlignment(
                .center
            )
        }
        .padding()
        .background(
            .ultraThinMaterial
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }

    private var controls:
        some View {

        HStack {

            Button("Reset") {

                viewModel.reset()
            }

            Spacer()

            Button("Measure") {

                viewModel.measureObject()

                if let dimensions =
                    viewModel.measuredDimensions {

                    onComplete(
                        dimensions
                    )
                }
            }
            .buttonStyle(
                .borderedProminent
            )
        }
        .padding()
        .background(
            .ultraThinMaterial
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }
}
