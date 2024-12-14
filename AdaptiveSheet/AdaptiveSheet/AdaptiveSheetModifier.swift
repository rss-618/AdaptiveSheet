import SwiftUI

public struct AdaptiveSheetModifier<T: View>: ViewModifier {
    
    @Binding var isPresented: SheetDisplay
    
    let sheetContent: T
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
         content: T) {
        self.sheetContent = content
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.scrollingExpandsWhenScrolledToEdge = scrollingExpandsWhenScrolledToEdge
        self.organicDismissalCompletion = organicDismissalCompletion
        self._isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            AdaptiveSheetPresenter(isPresented: $isPresented,
                                   detents: detents,
                                   largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                   scrollingExpandsWhenScrolledToEdge: scrollingExpandsWhenScrolledToEdge,
                                   prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                   organicDismissalCompletion: organicDismissalCompletion,
                                   content: sheetContent)
            .frame(width: .zero, height: .zero)
            
            content
        }
    }
    
}
