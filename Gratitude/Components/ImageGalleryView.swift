//
//  ImagePickerView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import PhotosUI

struct ImageGalleryView: UIViewControllerRepresentable {
    @Binding var images : [UIImage]
    let limit: Int
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = max(0, limit - images.count)
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImageGalleryView
        
        init(_ parent: ImageGalleryView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            results.forEach { result in
                if result.itemProvider.canLoadObject(ofClass: UIImage.self){
                    result.itemProvider.loadObject(ofClass: UIImage.self) { unsafeImage, _ in
                        if let image = unsafeImage as? UIImage{
                            self.parent.images.append(image)
                        }
                    }
                }
            }
        }
    }
}
