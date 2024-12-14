//
//  Ext_View.swift
//  AdaptiveSheet
//
//  Created by Ryan Schildknecht on 12/13/24.
//

import SwiftUI

extension View {
    /// A Multi-Stage Sheet with a Middle Stage and a Large Stage
    ///
    /// This is a iOS 15 limited representation of UISheetPresentation Controller.
    /// With iOS 16 we are provided a Custom Stage and are allowed to use custom heights.
    /// (Optional) with iOS 16 we can replace this with `.sheet`, but will be mising some functionality
    ///
    /// Cannot use `@Environment(\.dismiss) var dismiss` to display the sheet since we use the UIKit version
    ///
    /// `SheetDisplay` enum gives the option of a dismissal completion
    ///
    /// - Parameters:
    ///   - isPresented: Binding of a `SheetDisplay` enum
    ///   - detents: Array of detents the sheet can display at
    ///   - largestUndimmedDetentIdentifier: Determines whether we have a transparent background or not
    ///   `nil` always have opaque background
    ///   `.medium()` clear background on medium, opaque background on `.large()`
    ///   `.large()` always clear background
    ///   - prefersScrollingExpandsWhenScrolledToEdge: Boolean that determines whether not a nested scroll view will impact sheet movement
    ///   - prefersEdgeAttachedInCompactHeight: Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class
    ///   - content: `@ViewBuilder` Completion that builds the content view
    /// - Returns: The modified view
    public func adaptiveSheet<T: View>(_ isPresented: Binding<SheetDisplay>,
                                       detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                                       largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                                       scrollingExpandsWhenScrolledToEdge: Bool = true,
                                       prefersEdgeAttachedInCompactHeight: Bool = true,
                                       organicDismissalCompletion: (() -> Void)? = nil,
                                       @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(AdaptiveSheetModifier(isPresented: isPresented,
                                       detents: detents,
                                       largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                       scrollingExpandsWhenScrolledToEdge: scrollingExpandsWhenScrolledToEdge,
                                       prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                       organicDismissalCompletion: organicDismissalCompletion,
                                       content: content()))
    }
    
    /// A Multi-Stage Sheet with a Middle Stage and a Large Stage
    ///
    /// This is a iOS 15 limited representation of UISheetPresentation Controller.
    /// With iOS 16 we are provided a Custom Stage and are allowed to use custom heights.
    /// (Optional) with iOS 16 we can replace this with `.sheet`, but will be mising some functionality
    ///
    /// Cannot use `@Environment(\.dismiss) var dismiss` to display the sheet since we use the UIKit version
    ///
    /// `SheetDisplay` enum gives the option of a dismissal completion
    ///
    /// - Parameters:
    ///   - isPresented: Binding of `Bool`
    ///   - detents: Array of detents the sheet can display at
    ///   - largestUndimmedDetentIdentifier: Determines whether we have a transparent background or not
    ///   `nil` always have opaque background
    ///   `.medium()` clear background on medium, opaque background on `.large()`
    ///   `.large()` always clear background
    ///   - prefersScrollingExpandsWhenScrolledToEdge: Boolean that determines whether not a nested scroll view will impact sheet movement
    ///   - prefersEdgeAttachedInCompactHeight: Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class
    ///   - content: `@ViewBuilder` Completion that builds the content view
    /// - Returns: The modified view
    public func adaptiveSheet<T: View>(_ isPresented: Binding<Bool>,
                                       detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                                       largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                                       scrollingExpandsWhenScrolledToEdge: Bool = true,
                                       prefersEdgeAttachedInCompactHeight: Bool = true,
                                       organicDismissalCompletion: (() -> Void)? = nil,
                                       @ViewBuilder content: @escaping () -> T) -> some View {
        // Translate Binding into SheetDisplay Binding
        let newBinding: Binding<SheetDisplay> = Binding(get: {
            SheetDisplay.parse(isPresented.wrappedValue)
        },
                                                        set: {
            isPresented.wrappedValue = $0.boolValue
        })
        // Utilize existing extension
        return self.adaptiveSheet(newBinding,
                                  detents : detents,
                                  largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                  scrollingExpandsWhenScrolledToEdge: scrollingExpandsWhenScrolledToEdge,
                                  prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                  organicDismissalCompletion: organicDismissalCompletion,
                                  content: content)
    }
}
