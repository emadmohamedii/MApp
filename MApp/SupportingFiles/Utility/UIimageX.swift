//
//  UIimageX.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    public func downloadImageWithCaching(with url: String,placeholderImage: UIImage? = nil){
        if url == ""{
            self.image = placeholderImage
            return
        }
        guard let imageURL = URL.init(string: url) else{
            self.image = placeholderImage
            return
        }
        DispatchQueue.main.async {
            self.sd_imageTransition = .fade
            self.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
        }
    }
}
