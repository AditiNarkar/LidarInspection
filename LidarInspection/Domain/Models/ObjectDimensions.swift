//
//  ObjectDimensions.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//
import Foundation

struct ObjectDimensions: Equatable, Sendable {

    let width: Float
    let breadth: Float
    let height: Float

    init(
        width: Float,
        breadth: Float,
        height: Float
    ) {
        self.width = width
        self.breadth = breadth
        self.height = height
    }
}
