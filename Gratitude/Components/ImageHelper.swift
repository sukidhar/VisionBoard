//
//  ImageHelper.swift
//  Gratitude
//
//  Created by sukidhar on 02/10/22.
//

import UIKit
import Kingfisher

class ImageHelper {
    @discardableResult
    func saveImage(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            let uuid = UUID()
            let path = directory.appendingPathComponent("\(uuid.uuidString).png")!
            try data.write(to: path)
            return uuid.uuidString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func getImageResource(_ link: String) -> ImageResource?{
        guard let url = URL(string: link) else {
            return nil
        }
        return .init(downloadURL: url, cacheKey: link)
    }
}
