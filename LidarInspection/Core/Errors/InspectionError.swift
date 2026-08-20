//
//  InspectionError.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//
import Foundation

enum InspectionError: LocalizedError {

    case lidarUnavailable
    case sceneReconstructionUnavailable
    case objectNotDetected
    case insufficientMeshData
    case measurementFailed

    var errorDescription: String? {

        switch self {

        case .lidarUnavailable:
            return "LiDAR is not available on this device."

        case .sceneReconstructionUnavailable:
            return "Scene reconstruction is not supported on this device."

        case .objectNotDetected:
            return "The object could not be detected."

        case .insufficientMeshData:
            return "Not enough LiDAR data was collected."

        case .measurementFailed:
            return "The object dimensions could not be calculated."
        }
    }
}
