import SwiftUI

struct ResultsView: View {

    @StateObject private var viewModel: ResultsViewModel
    let onNewInspection: () -> Void
    let scanner: LiDARScanner
    @State private var isShowingMeshReview = false

    init(
        expected: ObjectDimensions,
        measured: MeasuredDimensions,
        scanner: LiDARScanner,
        onNewInspection: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: ResultsViewModel(
                expected: expected,
                measured: measured
            )
        )
        self.scanner = scanner
        self.onNewInspection = onNewInspection
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                statusSection

                dimensionsSection

                Button("Review 3D Mesh") {
                    isShowingMeshReview = true
                }
                .buttonStyle(.bordered)

                Button("Start New Inspection", action: onNewInspection)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Inspection Results")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingMeshReview) {
            MeshReviewView(scanner: scanner)
        }
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
                deviation: viewModel.result.widthDeviation,
                tolerance: viewModel.result.tolerance.width,
                isWithinTolerance: viewModel.result.widthWithinTolerance
            )

            dimensionRow(
                name: "Height",
                expected: viewModel.result.expected.height,
                measured: viewModel.result.measured.height,
                deviation: viewModel.result.heightDeviation,
                tolerance: viewModel.result.tolerance.height,
                isWithinTolerance: viewModel.result.heightWithinTolerance
            )

            dimensionRow(
                name: "Breadth",
                expected: viewModel.result.expected.breadth,
                measured: viewModel.result.measured.breadth,
                deviation: viewModel.result.breadthDeviation,
                tolerance: viewModel.result.tolerance.breadth,
                isWithinTolerance: viewModel.result.breadthWithinTolerance
            )
        }
    }

    // MARK: - Dimension Row

    private func dimensionRow(
        name: String,
        expected: Float,
        measured: Float,
        deviation: Float,
        tolerance: Float,
        isWithinTolerance: Bool
    ) -> some View {

        HStack {
            Label(name, systemImage: isWithinTolerance ? "checkmark.circle.fill" : "xmark.circle.fill")
                .fontWeight(.semibold)
                .foregroundStyle(isWithinTolerance ? .green : .red)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Expected: \(expected * 1_000, specifier: "%.1f") mm")
                Text("Measured: \(measured * 1_000, specifier: "%.1f") mm")
                Text("Deviation: \(deviation * 1_000, specifier: "%+.1f") mm")
                Text("Tolerance: ±\(tolerance * 1_000, specifier: "%.1f") mm")
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
