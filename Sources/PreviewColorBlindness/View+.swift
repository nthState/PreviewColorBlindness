//
//  View+.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/master/LICENSE for license information.
//

import SwiftUI
import CoreGraphics

extension View {
  
  func asImage() -> UIImage {
    
    let controller = UIHostingController(rootView: self)
    let view = controller.view
    let targetSize = controller.view.intrinsicContentSize
    let bounds = CGRect(origin: .zero, size: targetSize)
    
    let window = UIWindow()
   
    window.rootViewController = controller
    window.makeKeyAndVisible()
    
    view?.bounds = bounds
    view?.backgroundColor = .clear
    
    let image = controller.view.asImage()
    
    return image
  }
}

extension UIView {
  func asImage() -> UIImage {
    
    let traitCollection = UITraitCollection(displayScale: 2.0)
    let format = UIGraphicsImageRendererFormat(for: traitCollection)
    
//    let format = UIGraphicsImageRendererFormat.default()
//    format.opaque = true
//    format.scale = 2
    
    let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
//    return renderer.image { rendererContext in
//      layer.render(in: rendererContext.cgContext)
//    }
    
    return renderer.image { ctx in
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
    }
  }
}
