//
//  PreviewColorBlindness.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
//

import SwiftUI
import MetalKit

/// What type of colour blindness to simulate
public enum ColorBlindnessType {
    case none
    case protanope
    case deuteranope
    case tritanopia
    case custom(float3x3)

    var colorMatrix: float3x3 {
        switch self {
        case .none:
            return simd_float3x3(1)
        case .protanope:
            return simd_matrix(
                SIMD3<Float>(0.567,0.433,0),
                SIMD3<Float>(0.558,0.442,0),
                SIMD3<Float>(0,0.242,0.758)
            )
        case .deuteranope:
            return simd_matrix(
                SIMD3<Float>(0.625,0.375,0),
                SIMD3<Float>(0.7,0.3,0),
                SIMD3<Float>(0,0.3,0.7)
            )
        case .tritanopia:
            return simd_matrix(
                SIMD3<Float>(0.95,0.05,0),
                SIMD3<Float>(0,0.433,0.567),
                SIMD3<Float>(0,0.475,0.525)
            )
        case .custom(let value):
            return value
        }
    }
}

public extension View {

    func previewColorBlindness(type: ColorBlindnessType, isEnabled: Bool = true) -> some View {

        func shader(type: ColorBlindnessType) -> Shader {
            let function = ShaderFunction(library: .bundle(.module), name: "colorBlindness")

            let matrix = type.colorMatrix

            let args: [Shader.Argument] = [
                .float(matrix[0][0]),
                .float(matrix[1][0]),
                .float(matrix[2][0]),

                .float(matrix[0][1]),
                .float(matrix[1][1]),
                .float(matrix[2][1]),

                .float(matrix[0][2]),
                .float(matrix[1][2]),
                .float(matrix[2][2]),
            ]

            let shader = Shader(function: function, arguments: args)

            return shader
        }
        return self.layerEffect(shader(type: type), maxSampleOffset: .init(width: 10, height: 10), isEnabled: isEnabled)
    }

}
