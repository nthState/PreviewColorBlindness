//
//  Shaders.metal
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

#include <metal_stdlib>
using namespace metal;

kernel void colorBlindness(texture2d<float, access::read> inTexture [[texture(0)]],
                      texture2d<float, access::write> outTexture [[texture(1)]],
                      constant float3x3 &colorMatrix [[buffer(0)]],
                      uint2 gid [[thread_position_in_grid]]) {
    float4 color = inTexture.read(gid).rgba;
    float3 mixed = color.rgb * colorMatrix;
    float4 combinedColor = float4(mixed, color.a);

    outTexture.write(combinedColor, gid);
}
