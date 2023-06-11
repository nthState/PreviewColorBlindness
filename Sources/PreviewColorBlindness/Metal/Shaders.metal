//
//  Shaders.metal
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4
colorBlindness(float2 position,
               SwiftUI::Layer layer,
               float m0,
               float m1,
               float m2,
               float m3,
               float m4,
               float m5,
               float m6,
               float m7,
               float m8
               ) {

    half3x3 colorMatrix;
    colorMatrix[0] = half3(m0, m1, m2);
    colorMatrix[1] = half3(m3, m4, m5);
    colorMatrix[2] = half3(m6, m7, m8);

    half4 color = layer.sample(position);
    half3 mixed = color.rgb * colorMatrix;
    half4 combinedColor = half4(mixed, color.a);

    return combinedColor;
}
