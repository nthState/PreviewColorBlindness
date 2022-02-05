# ``PreviewColorBlindness``

A Preview View Modifier to simulate Colour Blindness

## Overview

```
import PreviewColorBlindness

#if DEBUG
struct ExampleSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ExampleSwiftUIView()
        .previewColorBlindness(type: .protanope)
    }
  }
}
#endif

```

## Topics

### Guides

- <doc:Getting-Started-with-PreviewColorBlindness>
