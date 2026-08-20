//
//  ConfigurationViewModel.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import Foundation

@MainActor
final class ConfigurationViewModel:
    ObservableObject {

    @Published var width = ""

    @Published var breadth = ""

    @Published var height = ""

    @Published var errorMessage:
        String?

    func createDimensions()
        -> ObjectDimensions? {

        guard
            let widthValue =
                Float(width),

            let breadthValue =
                Float(breadth),

            let heightValue =
                Float(height)
        else {

            errorMessage =
                "Please enter valid dimensions."

            return nil
        }

        guard
            widthValue > 0,
            breadthValue > 0,
            heightValue > 0
        else {

            errorMessage =
                "Dimensions must be greater than zero."

            return nil
        }

        return ObjectDimensions(
            width: widthValue / 1000,
            breadth: breadthValue / 1000,
            height: heightValue / 1000
        )
    }
}
