//
//  Tolerance.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//
import Foundation

struct Tolerance: Equatable, Sendable {

    let width: Float
    let breadth: Float
    let height: Float

    static let defaultTolerance = Tolerance(
        width: 0.002,
        breadth: 0.002,
        height: 0.002
    )
}
