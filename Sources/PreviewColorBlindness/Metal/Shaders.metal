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

kernel void kernel_chromatic_aberration(texture2d<float, access::read> texture [[texture(0)]],
                                    texture2d<float, access::write> outTexture [[texture(1)]],
                                    constant int &rx [[buffer(0)]],
                                    constant int &gx [[buffer(1)]],
                                    constant int &bx [[buffer(2)]],
                                    constant int &ry [[buffer(3)]],
                                    constant int &gy [[buffer(4)]],
                                    constant int &by [[buffer(5)]],
                                    uint2 gid [[thread_position_in_grid]]
                                    ) {
  
  const float4 r = texture.read(uint2(gid.x - rx, gid.y + ry));
  const float4 g = texture.read(uint2(gid.x - gx, gid.y + gy));
  const float4 b = texture.read(uint2(gid.x - bx, gid.y + by));
  const float4 a = texture.read(uint2(gid));
  
  const float4 outColor = float4(r.r, g.g, b.b, a.a);
  
  outTexture.write(outColor, gid);
}
