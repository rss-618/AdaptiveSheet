import SwiftUI

/// A Multi-Stage Sheet with a Middle Stage and a Large Stage
class AdaptiveSheetViewController<Content: View>: UIViewController {
    
    var content: Content
    
    let coordinator: AdaptiveSheetPresenter<Content>.Coordinator
    let detents : [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let scrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    
    init(coordinator: AdaptiveSheetPresenter<Content>.Coordinator,
         detents : [UISheetPresentationController.Detent],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?,
         scrollingExpandsWhenScrolledToEdge: Bool,
         prefersEdgeAttachedInCompactHeight: Bool,
         content: Content) {
        self.content = content
        self.coordinator = coordinator
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.scrollingExpandsWhenScrolledToEdge = scrollingExpandsWhenScrolledToEdge
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissSheet(_ completion: (() -> Void)? = nil) {
        if presentedViewController != nil {
            dismiss(animated: true, completion: completion)
        }
    }
    
    func presentSheet() {
        if presentedViewController == nil {
            let hostingController = UIHostingController(rootView: content)
            hostingController.modalPresentationStyle = .pageSheet
            hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
            hostingController.modalTransitionStyle = .coverVertical
            
            if let sheet = hostingController.sheetPresentationController {
                sheet.detents = detents
                sheet.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
                sheet.prefersScrollingExpandsWhenScrolledToEdge = scrollingExpandsWhenScrolledToEdge
                sheet.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
            
            present(hostingController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissSheet()
        super.viewWillDisappear(animated)
    }
    
}
