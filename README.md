# SimpleDeclarativeSyntax

This is a demo project of my presentation: [Declarative UI without SwiftUI](https://speakerdeck.com/koromiko/declarative-ui-without-swiftui)


## Introduction

DeclaratvieUI is a good pattern for crafting complex UI components while keeping the states simple. SwiftUI is one of the best frameworks of Declarative UI pattern. However, due to the ABI stability, we cannot use SwiftUI, or even those syntax supporting declarative programming, on devices below iOS 13.

In this project, we did some simple experiment on declarative UI, and created a simple design for converting the current UI into declarative pattern.


## Usage

This is the main part for putting all you UI code.

```swift 
func render() -> [ViewNode] {
    return [
        .label(state1),
        .label(state3),
        .button(state2),
    ]
}
``` 

All you have to do is to conform your view controller or view to `ViewComponent` protocol. Like this:

```swift
var hostView: DiffingRenderer = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.spacing = 10
    stackView.alignment = .leading
    return stackView
}()

lazy var renderCoordinator: RenderCycleCoordinator = {
    return RenderCycleCoordinator(viewComponent: self)
}()
```

The layout direction is controlled by your view controller's implementation, instead of HStack or VStack as they're in SwiftUI. This inversion makes customization possible and easy to be maintained.


## Design

Basically,

* ViewComponent - The owner and container of all the module
* ViewNode - The abstract of a view.  
* DifferingRenderer - Handles the hands-on rendering of UIKit 
* DifferingProvider - Provides edit distance algorithm.


Details are TBD.

For Chinese reader, please check the slide out :) 

[Declarative UI without SwiftUI](https://speakerdeck.com/koromiko/declarative-ui-without-swiftui)

## Future

* Finish documentation
* Typed ViewNode and ViewState.
* Multi layer view support.
