//
//  MTLTexture+.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/master/LICENSE for license information.
//

import MetalKit
import Metal
import MetalPerformanceShaders
import Accelerate

extension MTLTexture {
  
  func uiImage() -> UIImage? {
    guard let cgImage = cgImage else {
      return nil
    }
    return UIImage(cgImage: cgImage)
  }
  
  var cgImage: CGImage? {
    
    //assert(self.pixelFormat == .bgra8Unorm)
    // read texture as byte array
    let rowBytes = self.width * 4
    let length = rowBytes * self.height
    let bgraBytes = [UInt8](repeating: 0, count: length)
    let region = MTLRegionMake2D(0, 0, self.width, self.height)
    self.getBytes(UnsafeMutableRawPointer(mutating: bgraBytes), bytesPerRow: rowBytes, from: region, mipmapLevel: 0)
    
    // use Accelerate framework to convert from BGRA to RGBA
    var bgraBuffer = vImage_Buffer(data: UnsafeMutableRawPointer(mutating: bgraBytes),
                                   height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: rowBytes)
    let rgbaBytes = [UInt8](repeating: 0, count: length)
    var rgbaBuffer = vImage_Buffer(data: UnsafeMutableRawPointer(mutating: rgbaBytes),
                                   height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: rowBytes)
    let map: [UInt8] = [2, 1, 0, 3]
    vImagePermuteChannels_ARGB8888(&bgraBuffer, &rgbaBuffer, map, 0)
    
    //        // flipping image vertically
    //        let flippedBytes = bgraBytes // share the buffer
    //        var flippedBuffer = vImage_Buffer(data: UnsafeMutableRawPointer(mutating: flippedBytes),
    //                                          height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: rowBytes)
    //        vImageVerticalReflect_ARGB8888(&rgbaBuffer, &flippedBuffer, 0)
    // create CGImage with RGBA
    let colorScape = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    guard let data = CFDataCreate(nil, rgbaBytes, length) else { return nil }
    guard let dataProvider = CGDataProvider(data: data) else { return nil }
    let cgImage = CGImage(width: self.width, height: self.height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: rowBytes,
                          space: colorScape, bitmapInfo: bitmapInfo, provider: dataProvider,
                          decode: nil, shouldInterpolate: true, intent: .defaultIntent)
    return cgImage
  }
  
}
