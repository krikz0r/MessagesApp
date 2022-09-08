//
//  Extension + UIView.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit
extension UIImage {
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            $0 / 180.0 * CGFloat(Double.pi)
        }

        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, 0)
        let bitmap = UIGraphicsGetCurrentContext()

        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)

        bitmap!.rotate(by: degreesToRadians(degrees))

        var yFlip: CGFloat

        if flip {
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }

        bitmap!.scaleBy(x: yFlip, y: -1.0)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
