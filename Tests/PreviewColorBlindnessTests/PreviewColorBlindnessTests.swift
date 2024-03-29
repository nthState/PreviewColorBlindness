//
//  PreviewColorBlindnessTests.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
//

import SwiftUI
import XCTest
@testable import PreviewColorBlindness

final class PreviewColorBlindnessTests: XCTestCase {
  
    @MainActor
    func test_protanope_renders_correctly() throws {

    let view = ExampleSwiftUIView()
          .previewColorBlindness(type: .protanope)

      let renderer = ImageRenderer(content: view)

      guard let uiImage = renderer.uiImage else {
          return XCTFail("Image not generated")
      }

//    let runner = ColorBlindness(view: view, type: .protanope)
//
//    let image = runner.createImage()
//    
//    // Uncomment next line to generate image
//    //let _ = try image.save(to: URL(fileURLWithPath: "/Users/chrisdavis/Tests/test_1.jpg"))
//    
//    // Actual
//    let actual_url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("generated_1.jpg")
//    let _ = try image?.save(to: actual_url)
//    
//    // Expected
//    let expected_url = Bundle.module.url(forResource: "test_1", withExtension: "jpg")!
//    
//    let result = FileManager.default.contentsEqual(atPath: actual_url.path, andPath: expected_url.path)
//    XCTAssertTrue(result, "Generated image should match")
    
  }
  
}
