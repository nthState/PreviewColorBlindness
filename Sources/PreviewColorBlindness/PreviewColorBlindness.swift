//
//  PreviewColorBlindness.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/master/LICENSE for license information.
//

import SwiftUI
import MetalKit

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

extension View {

    func previewColorBlindness(type: ColorBlindnessType) -> some View {
        modifier(ColorBlindness(view: self, type: type))
    }

}

struct ColorBlindness<V>: ViewModifier where V: View {

    let view: V
    let type: ColorBlindnessType
    @State var image: UIImage?
    @State var imageSize: CGSize = .zero

    private func createReferenceImage() async -> UIImage? {
        //try? await Task.sleep(nanoseconds: UInt64(0.032 * Double(NSEC_PER_SEC)))
        //sleep(UInt32(0.032))
        let engine = MetalEngine.instance
        let snapshotImage = view.asImage()
        var texture = snapshotImage.textureFromImage(device: engine.device)
        engine.apply(newTex: &texture, colorMatrix: type.colorMatrix)
        let outputImage = texture?.uiImage()

        self.imageSize = snapshotImage.size

        return outputImage
    }

    public func body(content: Content) -> some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
            } else {
                view
            }
        }
        .padding(0)
        .task {
            image = await createReferenceImage()
        }
    }

}
