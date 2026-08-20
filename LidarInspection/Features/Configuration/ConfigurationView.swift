import SwiftUI

struct ConfigurationView: View {

    @StateObject private var viewModel =
        ConfigurationViewModel()

    let onContinue:
        (ObjectDimensions) -> Void

    var body: some View {

        Form {

                Section(
                    header: Text("Expected Dimensions")
                ) {

                    dimensionField(
                        title: "Width",
                        value:
                            $viewModel.width
                    )

                    dimensionField(
                        title: "Breadth",
                        value:
                            $viewModel.breadth
                    )

                    dimensionField(
                        title: "Height",
                        value:
                            $viewModel.height
                    )
                }

                Section {

                    Text(
                        "Enter the nominal dimensions of the manufactured object in millimetres."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                Button("Start Inspection") {

                    guard
                        let dimensions =
                            viewModel
                            .createDimensions()
                    else {
                        return
                    }

                    onContinue(dimensions)
                }
            }
        .navigationTitle(
            "Object Configuration"
        )
        .alert(
            "Invalid Input",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {

            Button("OK") {

                viewModel.errorMessage = nil
            }

        } message: {

            Text(
                viewModel.errorMessage ?? ""
            )
        }
    }

    private func dimensionField(
        title: String,
        value: Binding<String>
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            TextField(
                "mm",
                text: value
            )
            .keyboardType(
                .decimalPad
            )
            .multilineTextAlignment(
                .trailing
            )

            Text("mm")
                .foregroundStyle(
                    .secondary
                )
        }
    }
}
