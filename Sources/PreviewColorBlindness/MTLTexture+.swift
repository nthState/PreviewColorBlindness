//
//  MTLTexture+.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
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
    
    let rowBytes = self.width * 4
    let length = rowBytes * self.height
    var bgraBytes = [UInt8](repeating: 0, count: length)
    var bgraBuffer: vImage_Buffer?
    let region = MTLRegionMake2D(0, 0, self.width, self.height)
    bgraBytes.withUnsafeMutableBytes { ptr in
      self.getBytes(ptr.baseAddress!, bytesPerRow: rowBytes, from: region, mipmapLevel: 0)
      bgraBuffer = vImage_Buffer(data: ptr.baseAddress!,
                                     height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: rowBytes)
    }

    var rgbaBuffer: vImage_Buffer?
    var rgbaBytes = [UInt8](repeating: 0, count: length)
    rgbaBytes.withUnsafeMutableBytes { ptr in
      rgbaBuffer = vImage_Buffer(data: ptr.baseAddress!,
                                     height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: rowBytes)
    }

    let map: [UInt8] = [2, 1, 0, 3]
    vImagePermuteChannels_ARGB8888(&bgraBuffer!, &rgbaBuffer!, map, 0)

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
