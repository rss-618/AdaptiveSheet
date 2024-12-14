import SwiftUI

/// A Multi-Stage Sheet with a Middle Stage and a Large Stage
///
/// This is a iOS 15 limited representation of UISheetPresentation Controller.
/// With iOS 16 we are provided a Custom Stage and are allowed to use custom heights.
/// (Optional) with iOS 16 we can replace this with `.sheet`, but will be mising some functionality
///
/// Cannot use `@Environment(\.dismiss) var dismiss` to display the sheet since we use the UIKit version
///
/// `SheetDisplay` enum gives the option of a dismissal completion
struct AdaptiveSheetPresenter<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: SheetDisplay
    @State var isCurrentlyDisplayed: Bool = false
    
    let content: Content
    let detents: [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let scrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let organicDismissalCompletion: (() -> Void)?

    init(isPresented: Binding<SheetDisplay>,
         detents: [UISheetPresentationController.Detent],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?,
         scrollingExpandsWhenScrolledToEdge: Bool,
         prefersEdgeAttachedInCompactHeight: Bool,
         organicDismissalCompletion: (() -> Void)?,
         content: Content) {
        self.content = content
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.scrollingExpandsWhenScrolledToEdge = scrollingExpandsWhenScrolledToEdge
        self.organicDismissalCompletion = organicDismissalCompletion
        self._isPresented = isPresented
    }
    
    /// Creates instance of Coordinator linked with `AdaptiveSheetPresenter`
    /// - Returns: Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates initial ViewController instance
    /// - Parameter context: Contex
    /// - Returns: ViewController
    func makeUIViewController(context: Context) -> AdaptiveSheetViewController<Content> {
        return AdaptiveSheetViewController(coordinator: context.coordinator,
                                           detents: detents,
                                           largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                           scrollingExpandsWhenScrolledToEdge:  scrollingExpandsWhenScrolledToEdge,
                                           prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                           content: content)
    }
    
    /// Updates ViewController everytime this UIViewControllerRepresentable state is modified
    /// - Parameters:
    ///   - uiViewController: ViewController
    ///   - context: Context
    func updateUIViewController(_ uiViewController: AdaptiveSheetViewController<Content>, context: Context) {
        DispatchQueue.main.async {
            // Keep view up-to-date
            uiViewController.content = content
            
            // Attempt Presenting or Dismissing
            if case .displayed = isPresented {
                // Present
                uiViewController.presentSheet()
                isCurrentlyDisplayed = true
            } else if case .dismissed(let completion) = isPresented,
                      isCurrentlyDisplayed {
                // Only dismiss if still showing
                uiViewController.dismissSheet(completion)
                isCurrentlyDisplayed = false
            }
        }
    }
    
    /// Delegate that communicates the ViewController to the SwiftUI end
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        
        var parent: AdaptiveSheetPresenter
        
        init(_ parent: AdaptiveSheetPresenter) {
            self.parent = parent
        }
        
        /// Delegate call from the adaptive sheet
        /// - Parameter presentationController: The SwiftUI representation of the view
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isCurrentlyDisplayed {
                // If this boolean is still true, this was an organic dismiss
                parent.organicDismissalCompletion?()
            }
            parent.isCurrentlyDisplayed = false
            parent.isPresented = .dismissed()
        }
        
    }
}
