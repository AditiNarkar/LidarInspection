import SwiftUI

struct ResultsView: View {

    @StateObject private var viewModel: ResultsViewModel

    init(
        expected: ObjectDimensions,
        measured: MeasuredDimensions
    ) {
        _viewModel = StateObject(
            wrappedValue: ResultsViewModel(
                expected: expected,
                measured: measured
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                statusSection

                dimensionsSection
            }
            .padding()
        }
        .navigationTitle("Inspection Results")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Status

    private var statusSection: some View {
        VStack(spacing: 8) {

            Text(viewModel.result.status.rawValue)
                .font(
                    .system(
                        size: 36,
                        weight: .bold
                    )
                )

            Text(
                viewModel.result.status == .pass
                ? "Object is within tolerance."
                : "Object exceeds the allowed tolerance."
            )
            .font(.subheadline)
        }
    }

    // MARK: - Dimensions

    private var dimensionsSection: some View {
        VStack(spacing: 12) {

            dimensionRow(
                name: "Width",
                expected: viewModel.result.expected.width,
                measured: viewModel.result.measured.width,
                deviation: viewModel.result.widthDeviation
            )

            dimensionRow(
                name: "Height",
                expected: viewModel.result.expected.height,
                measured: viewModel.result.measured.height,
                deviation: viewModel.result.heightDeviation
            )

            dimensionRow(
                name: "Breadth",
                expected: viewModel.result.expected.breadth,
                measured: viewModel.result.measured.breadth,
                deviation: viewModel.result.breadthDeviation
            )
        }
    }

    // MARK: - Dimension Row

    private func dimensionRow(
        name: String,
        expected: Float,
        measured: Float,
        deviation: Float
    ) -> some View {

        HStack {
            Text(name)
                .fontWeight(.semibold)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Expected: \(expected, specifier: "%.2f")")
                Text("Measured: \(measured, specifier: "%.2f")")
                Text("Deviation: \(deviation, specifier: "%+.2f")")
            }
            .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
