import UIKit
import Foundation

public final class ImageCache {
    @MainActor public static let shared = ImageCache()

    private let cachedImages = NSCache<NSString, UIImage>()

    func load(urlString: String) async -> (UIImage?, String) {
       if let cachedImage = cachedImages.object(forKey: urlString as NSString) {
           return (cachedImage, urlString)
       }

       guard let url = URL(string: urlString) else {
           return (nil, urlString)
       }

       do {
           let (data, _) = try await URLSession.shared.data(from: url)
           if let image = UIImage(data: data) {
               // Store the downloaded image in cache
               cachedImages.setObject(image, forKey: urlString as NSString)
               return (image, urlString)
           } else {
               return (nil, urlString)
           }
       } catch {
           // Handle error (e.g., network issue)
           return (nil, urlString)
       }
   }
}
