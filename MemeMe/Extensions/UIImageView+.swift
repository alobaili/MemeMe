//
//  UIImageView+.swift
//  MemeMe
//
//  Created by Abdulaziz AlObaili on 19/09/2020.
//  Copyright © 2020 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public var scaleFactor: CGFloat {
        guard let image = image, frame != .zero else {
            return 0.0
        }
        
        let extent = image.size
        let heightFactor = frame.height / extent.height
        let widthFactor = frame.width / extent.width
        
        if extent.height > frame.height || extent.width > frame.width {
            if heightFactor < 1 && widthFactor < 1 {
                if heightFactor > widthFactor {
                    return widthFactor
                } else {
                    return heightFactor
                }
            } else if extent.height > frame.height {
                return heightFactor
            } else {
                return widthFactor
            }
        } else if extent.height < frame.height && extent.width < frame.width {
            if heightFactor < widthFactor {
                return heightFactor
            } else {
                return widthFactor
            }
        } else {
            return 1
        }
    }
    
    public var imageSize: CGSize {
        guard let image = image else { return .zero }
        
        return CGSize(width: image.size.width, height: image.size.height)
    }
    
    public var scaledSize:CGSize {
        guard let image = image, frame != .zero else { return .zero }
        
        let factor = scaleFactor
        return CGSize(width: image.size.width * factor, height: image.size.height * factor)
    }
    
    
}

