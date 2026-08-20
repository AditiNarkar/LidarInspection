import SwiftUI

struct MeshReviewView: View {

    @Environment(\.dismiss) private var dismiss

    let scanner: LiDARScanner

    var body: some View {

        ZStack(alignment: .topTrailing) {

            ARViewContainer(
                scanner: scanner,
                showsMesh: true,
                onTap: { _ in }
            )
            .ignoresSafeArea()

            VStack(alignment: .trailing, spacing: 12) {

                Text("Captured 3D Mesh")
                    .font(.headline)

                Text("Move around the part to inspect mesh coverage. The coloured wireframe is ARKit's reconstructed scene mesh.")
                    .font(.caption)
                    .multilineTextAlignment(.trailing)

                Button("Done", action: dismiss.callAsFunction)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        .onAppear {
            try? scanner.resume()
        }
        .onDisappear {
            scanner.stop()
        }
    }
}
