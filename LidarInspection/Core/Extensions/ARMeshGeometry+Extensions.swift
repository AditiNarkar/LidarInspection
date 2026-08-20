//
//  ARMeshGeometry+Extensions.swift
//  LidarInspection
//
//  Created by Aditi Narkar on 20/8/2026.
//

import ARKit
import simd

extension ARMeshGeometry {

    func vertex(
        at index: Int
    ) -> SIMD3<Float> {

        precondition(index >= 0 && index < vertices.count)

        let pointer = vertices.buffer.contents()
            .advanced(by: vertices.offset + index * vertices.stride)

        return pointer.loadUnaligned(as: SIMD3<Float>.self)
    }

    func triangleIndices(at index: Int) -> SIMD3<UInt32> {

        precondition(index >= 0 && index < faces.count)
        precondition(faces.indexCountPerPrimitive == 3)

        let pointer = faces.buffer.contents().advanced(
            by: index * faces.indexCountPerPrimitive * faces.bytesPerIndex
        )

        func indexValue(at offset: Int) -> UInt32 {
            let indexPointer = pointer.advanced(by: offset * faces.bytesPerIndex)

            switch faces.bytesPerIndex {
            case 2:
                return UInt32(indexPointer.loadUnaligned(as: UInt16.self))
            case 4:
                return indexPointer.loadUnaligned(as: UInt32.self)
            default:
                preconditionFailure("Unsupported AR mesh index size.")
            }
        }

        return SIMD3<UInt32>(
            indexValue(at: 0),
            indexValue(at: 1),
            indexValue(at: 2)
        )
    }
}
