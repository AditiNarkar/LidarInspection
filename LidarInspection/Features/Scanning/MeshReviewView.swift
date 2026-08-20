import SwiftUI
import RealityKit
import ARKit

struct MeshReviewView: View {

    @Environment(\.dismiss) private var dismiss

    let scanner: LiDARScanner

    var body: some View {

        ZStack(alignment: .topTrailing) {

            StaticMeshReviewContainer(
                scanner: scanner,
                anchors: scanner.meshAnchorsSnapshot()
            )
            .ignoresSafeArea()

            VStack(alignment: .trailing, spacing: 12) {

                Text("Captured 3D Mesh (Static)")
                    .font(.headline)

                Text("This is the mesh captured before measurement. It is frozen for verification and will not collect new scan data.")
                    .font(.caption)
                    .multilineTextAlignment(.trailing)

                Button("Done", action: dismiss.callAsFunction)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding()
        }
    }
}

private struct StaticMeshReviewContainer: UIViewRepresentable {

    let scanner: LiDARScanner
    let anchors: [ARMeshAnchor]

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        arView.session = scanner.session

        let worldAnchor = AnchorEntity(world: .zero)
        for anchor in anchors {
            guard let model = makeModel(from: anchor) else {
                continue
            }

            model.transform = Transform(matrix: anchor.transform)
            worldAnchor.addChild(model)
        }

        arView.scene.addAnchor(worldAnchor)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    private func makeModel(from anchor: ARMeshAnchor) -> ModelEntity? {

        let geometry = anchor.geometry
        let positions = (0..<geometry.vertices.count).map { geometry.vertex(at: $0) }
        let triangles = (0..<geometry.faces.count).flatMap { faceIndex -> [UInt32] in
            let triangle = geometry.triangleIndices(at: faceIndex)
            return [triangle.x, triangle.y, triangle.z]
        }

        guard !positions.isEmpty, !triangles.isEmpty else {
            return nil
        }

        var descriptor = MeshDescriptor(name: "Captured mesh")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.primitives = .triangles(triangles)

        guard let mesh = try? MeshResource.generate(from: [descriptor]) else {
            return nil
        }

        let material = UnlitMaterial(color: .systemCyan.withAlphaComponent(0.65))
        return ModelEntity(mesh: mesh, materials: [material])
    }
}
