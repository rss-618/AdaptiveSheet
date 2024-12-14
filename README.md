# AdaptiveSheet
 An iOS 15 SwiftUI multi-dentent sheet adaptation from UIKit

A SwiftUI facing implementation of the a sheet with mutliple modes is iOS 16 locked. So if you want an iOS 15 "BSD" or half sheet that can be seamlessly transitioned into a full sheet, you need to use the UIKit implementation. This repository creates an interface to that UIKit instance of sheet, so it is usable on iOS 15.

## Specs 
### Display
Has the ability to be displayed through either
- A Binding of a `SheetDisplay` enum which consists of cases `displayed` and `dismissed((() -> Void)? = nil)` that allows for a dismissal completion
- A Binding of a `Bool` that just allows simple displaying and dismissal
### Detents
The Detents available are `.medium()` and/or `.large()`. These can be presented in an array for a Sheet that can be initially displayed and swiped to max height
### Largest Undimmed Detent Identifer
Determines whether we have a transparent background or not
- `nil` always have opaque background
-  `.medium()` clear background on medium, opaque background on `.large()`
-  `.large()` always clear background
### Prefers Scrolling Exapnds when Scrolled to Edge
Boolean that determines whether not a nested scroll view will impact sheet movement
### Prefers Edge Attached in CompactHeight
Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class
### Organic Dismissal
A completion that executes only when the sheet is dismiss through non-code initiated means. eg.) a user swipes down on the sheet or taps the area behind the sheet if undimmed setting is off where it is dimmed.

## Example
```
import AdaptiveSheet

...

@State var isPresented: SheetDisplay = .dismissed(nil)

...

Button {
    // Present Action
    isPresented = .displayed
} label: {
    Text("I'm a button")
}.adaptiveSheet($isPresented, detents: [.medium(), .large()]) {
    Button {
        // Dismiss Action
        isPresented = .dismissed {
            // Dismiss Completion
            print("I've been dismissed")
        }
    } label: {
        Text("Dismiss")
    }
}
```


