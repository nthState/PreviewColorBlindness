//
//  MetalEngine.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
//

import Metal
import MetalKit

class MetalEngine {
  
  public static var instance = MetalEngine()
  
  /// Metal function we are using
  private var kernelFunction:MTLFunction?
  /// Metal device, the GPU
  public var device: MTLDevice!
  /// Pipeline
  private var pipelineState: MTLComputePipelineState!
  /// Library
  private var defaultLibrary: MTLLibrary!
  /// Command queue
  private var commandQueue: MTLCommandQueue!
  /// Threading
  private var threadsPerThreadgroup:MTLSize!
  /// Thread Groups
  private var threadgroupsPerGrid: MTLSize!
  
  private init() {
    device = MTLCreateSystemDefaultDevice()
    defaultLibrary = try! device!.makeDefaultLibrary(bundle: Bundle.module)
    commandQueue = device!.makeCommandQueue()
    
    kernelFunction = defaultLibrary.makeFunction(name: "colorBlindness")
    
    do {
      pipelineState = try device!.makeComputePipelineState(function: kernelFunction!)
    }
    catch {
      fatalError("Unable to create pipeline state")
    }
  }
  
  func apply(newTex: inout MTLTexture?, colorMatrix: float3x3, size: CGSize) {
    
    threadsPerThreadgroup = MTLSizeMake(16, 16, 1)
    let widthInThreadgroups = (Int(size.width) + threadsPerThreadgroup.width - 1) / threadsPerThreadgroup.width
    let heightInThreadgroups = (Int(size.height) + threadsPerThreadgroup.height - 1) / threadsPerThreadgroup.height
    threadgroupsPerGrid = MTLSizeMake(widthInThreadgroups, heightInThreadgroups, 1)
    
    var color = colorMatrix
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
    commandEncoder?.setComputePipelineState(pipelineState)
    commandEncoder?.setTexture(newTex, index: 0)
    commandEncoder?.setTexture(newTex, index: 1)
    commandEncoder?.setBytes(&color, length: MemoryLayout<float3x3>.stride, index: 0)
    commandEncoder?.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
    commandEncoder?.endEncoding()
    commandBuffer?.commit();
    commandBuffer?.waitUntilCompleted()
    
  }
  
}
