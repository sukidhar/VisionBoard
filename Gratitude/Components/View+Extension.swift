//
//  View+Extension.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import Combine

extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
            .eraseToAnyPublisher()
    }
    
    func bottomSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView)->some View{
        return self
            .background {
                BottomSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            }
    }
}

struct BottomSheetHelper<SheetView: View> : UIViewControllerRepresentable {
    var sheetView : SheetView
    @Binding var showSheet : Bool
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet{
            let sheetController = SheetHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

class SheetHostingController<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        if let presentationController = self.presentationController as? UISheetPresentationController{
            presentationController.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.4
            })]
            presentationController.prefersGrabberVisible = true
            presentationController.preferredCornerRadius = 24
        }
    }
}
