//
//  ExampleSwiftUIView.swift
//  ChromaticAberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PreviewColorBlindness/blob/main/LICENSE for license information.
//

import SwiftUI

struct ExampleSwiftUIView {
  
}

extension ExampleSwiftUIView: View {
  
  var body: some View {
    content
  }
  
  var content: some View {
    VStack {
      text
      craig
    }
    .padding()
    .background(Color.green)
  }
  
  var text: some View {
    VStack {
      Text("This is blue text")
        .foregroundColor(.blue)
      Text("This is red text")
        .foregroundColor(.red)
      Text("This is yellow text")
        .foregroundColor(.yellow)
    }
  }
  
  var craig: some View {
    HStack {
      Image("craig", bundle: Bundle.module)
      Text("Craig")
    }
  }
  
}

#if DEBUG
struct ExampleSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ExampleSwiftUIView()
        .previewDisplayName("None")
      
      ExampleSwiftUIView()
        .previewColorBlindness(type: .protanope)
        .previewDisplayName("Protanope")
      
      ExampleSwiftUIView()
        .previewColorBlindness(type: .deuteranope)
        .previewDisplayName("Deuteranope")
      
      ExampleSwiftUIView()
        .previewColorBlindness(type: .tritanopia)
        .previewDisplayName("Tritanopia")
    }
  }
}
#endif

