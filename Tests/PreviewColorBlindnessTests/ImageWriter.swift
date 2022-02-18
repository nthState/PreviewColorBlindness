//
//  ImageWriter.swift
//  PreviewColorBlindness
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
//

import Foundation
import UIKit

extension UIImage {
  
  func save(to: URL) throws {
    if let data = self.jpegData(compressionQuality: 0.8) {
      try data.write(to: to)
    }
  }
  
}
