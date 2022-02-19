# ``PreviewColorBlindness``

A Preview View Modifier to simulate different types of Colour Blindness

## Overview

| Before | After |
|--------|-------|
![Before](01_Preview.png)|![After](03_Preview.png)

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
