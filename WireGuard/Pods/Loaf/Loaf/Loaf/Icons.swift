//
//  Icons.swift
//
//  Created on Feb 27, 2019.
//
//  Generated by PaintCode Plugin for Sketch
//  http://www.paintcodeapp.com/sketch
//

import UIKit



class Icons: NSObject {


    //MARK: - Canvas Drawings

    /// Page 1

    class func drawInfo(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 299, height: 302), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 299, height: 302), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 299, y: resizedFrame.height / 302)

        /// info
        do {
            context.saveGState()

            /// Path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 15, y: 105))
            path.addCurve(to: CGPoint(x: 30, y: 90.13), controlPoint1: CGPoint(x: 23.28, y: 105), controlPoint2: CGPoint(x: 30, y: 98.34))
            path.addLine(to: CGPoint(x: 30, y: 14.87))
            path.addCurve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 30, y: 6.66), controlPoint2: CGPoint(x: 23.28, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: 14.87), controlPoint1: CGPoint(x: 6.72, y: 0), controlPoint2: CGPoint(x: 0, y: 6.66))
            path.addLine(to: CGPoint(x: 0, y: 90.13))
            path.addCurve(to: CGPoint(x: 15, y: 105), controlPoint1: CGPoint(x: 0, y: 98.34), controlPoint2: CGPoint(x: 6.72, y: 105))
            path.close()
            context.saveGState()
            context.translateBy(x: 135, y: 121)
            UIColor.white.setFill()
            path.fill()
            context.restoreGState()

            /// Oval
            let oval = UIBezierPath()
            oval.move(to: CGPoint(x: 15, y: 30))
            oval.addCurve(to: CGPoint(x: 30, y: 15), controlPoint1: CGPoint(x: 23.28, y: 30), controlPoint2: CGPoint(x: 30, y: 23.28))
            oval.addCurve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 30, y: 6.72), controlPoint2: CGPoint(x: 23.28, y: 0))
            oval.addCurve(to: CGPoint(x: 0, y: 15), controlPoint1: CGPoint(x: 6.72, y: 0), controlPoint2: CGPoint(x: 0, y: 6.72))
            oval.addCurve(to: CGPoint(x: 15, y: 30), controlPoint1: CGPoint(x: 0, y: 23.28), controlPoint2: CGPoint(x: 6.72, y: 30))
            oval.close()
            context.saveGState()
            context.translateBy(x: 135, y: 75)
            UIColor.white.setFill()
            oval.fill()
            context.restoreGState()

            /// Shape
            let shape = UIBezierPath()
            shape.move(to: CGPoint(x: 149.5, y: 302))
            shape.addCurve(to: CGPoint(x: 299, y: 151), controlPoint1: CGPoint(x: 232.07, y: 302), controlPoint2: CGPoint(x: 299, y: 234.39))
            shape.addCurve(to: CGPoint(x: 149.5, y: 0), controlPoint1: CGPoint(x: 299, y: 67.61), controlPoint2: CGPoint(x: 232.07, y: 0))
            shape.addCurve(to: CGPoint(x: 0, y: 151), controlPoint1: CGPoint(x: 66.93, y: 0), controlPoint2: CGPoint(x: 0, y: 67.61))
            shape.addCurve(to: CGPoint(x: 43.79, y: 257.77), controlPoint1: CGPoint(x: 0, y: 191.05), controlPoint2: CGPoint(x: 15.75, y: 229.46))
            shape.addCurve(to: CGPoint(x: 149.5, y: 302), controlPoint1: CGPoint(x: 71.82, y: 286.09), controlPoint2: CGPoint(x: 109.85, y: 302))
            shape.close()
            shape.move(to: CGPoint(x: 149.5, y: 30.2))
            shape.addCurve(to: CGPoint(x: 269.1, y: 151), controlPoint1: CGPoint(x: 215.55, y: 30.2), controlPoint2: CGPoint(x: 269.1, y: 84.28))
            shape.addCurve(to: CGPoint(x: 149.5, y: 271.8), controlPoint1: CGPoint(x: 269.1, y: 217.72), controlPoint2: CGPoint(x: 215.55, y: 271.8))
            shape.addCurve(to: CGPoint(x: 29.9, y: 151), controlPoint1: CGPoint(x: 83.45, y: 271.8), controlPoint2: CGPoint(x: 29.9, y: 217.72))
            shape.addCurve(to: CGPoint(x: 149.5, y: 30.2), controlPoint1: CGPoint(x: 29.9, y: 84.28), controlPoint2: CGPoint(x: 83.45, y: 30.2))
            shape.close()
            context.saveGState()
            UIColor.white.setFill()
            shape.fill()
            context.restoreGState()

            context.restoreGState()
        }

        context.restoreGState()
    }

    class func drawSuccess(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 304, height: 302), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 304, height: 302), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 304, y: resizedFrame.height / 302)

        /// success
        do {
            context.saveGState()

            /// Group
            do {
                context.saveGState()

                /// Shape
                let shape = UIBezierPath()
                shape.move(to: CGPoint(x: 152.07, y: 0))
                shape.addCurve(to: CGPoint(x: 0, y: 150.88), controlPoint1: CGPoint(x: 68.24, y: 0), controlPoint2: CGPoint(x: 0, y: 67.71))
                shape.addCurve(to: CGPoint(x: 152.07, y: 301.63), controlPoint1: CGPoint(x: 0, y: 234.06), controlPoint2: CGPoint(x: 68.25, y: 301.63))
                shape.addCurve(to: CGPoint(x: 304, y: 150.88), controlPoint1: CGPoint(x: 235.88, y: 301.63), controlPoint2: CGPoint(x: 304, y: 234.05))
                shape.addCurve(to: CGPoint(x: 152.07, y: 0), controlPoint1: CGPoint(x: 304, y: 67.72), controlPoint2: CGPoint(x: 235.89, y: 0))
                shape.addLine(to: CGPoint(x: 152.07, y: 0))
                shape.close()
                shape.move(to: CGPoint(x: 152.07, y: 18.69))
                shape.addCurve(to: CGPoint(x: 285.17, y: 150.88), controlPoint1: CGPoint(x: 225.7, y: 18.69), controlPoint2: CGPoint(x: 285.17, y: 77.81))
                shape.addCurve(to: CGPoint(x: 152.07, y: 282.95), controlPoint1: CGPoint(x: 285.17, y: 223.96), controlPoint2: CGPoint(x: 225.71, y: 282.95))
                shape.addCurve(to: CGPoint(x: 18.83, y: 150.88), controlPoint1: CGPoint(x: 78.42, y: 282.95), controlPoint2: CGPoint(x: 18.83, y: 223.95))
                shape.addCurve(to: CGPoint(x: 152.07, y: 18.69), controlPoint1: CGPoint(x: 18.83, y: 77.82), controlPoint2: CGPoint(x: 78.43, y: 18.69))
                shape.close()
                context.saveGState()
                context.translateBy(x: -0, y: 0.22)
                shape.usesEvenOddFillRule = true
                UIColor.white.setFill()
                shape.fill()
                context.restoreGState()

                /// Path
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 153.03, y: 0.01))
                path.addCurve(to: CGPoint(x: 146.56, y: 2.84), controlPoint1: CGPoint(x: 150.58, y: 0.08), controlPoint2: CGPoint(x: 148.26, y: 1.1))
                path.addLine(to: CGPoint(x: 59.81, y: 89.03))
                path.addLine(to: CGPoint(x: 16.17, y: 45.61))
                path.addCurve(to: CGPoint(x: 7.03, y: 43.09), controlPoint1: CGPoint(x: 13.81, y: 43.2), controlPoint2: CGPoint(x: 10.31, y: 42.23))
                path.addCurve(to: CGPoint(x: 0.31, y: 49.73), controlPoint1: CGPoint(x: 3.75, y: 43.94), controlPoint2: CGPoint(x: 1.18, y: 46.48))
                path.addCurve(to: CGPoint(x: 2.83, y: 58.8), controlPoint1: CGPoint(x: -0.55, y: 52.98), controlPoint2: CGPoint(x: 0.41, y: 56.45))
                path.addLine(to: CGPoint(x: 53.14, y: 108.85))
                path.addCurve(to: CGPoint(x: 59.81, y: 111.6), controlPoint1: CGPoint(x: 54.91, y: 110.61), controlPoint2: CGPoint(x: 57.31, y: 111.6))
                path.addCurve(to: CGPoint(x: 66.47, y: 108.85), controlPoint1: CGPoint(x: 62.31, y: 111.6), controlPoint2: CGPoint(x: 64.71, y: 110.61))
                path.addLine(to: CGPoint(x: 159.88, y: 16.04))
                path.addCurve(to: CGPoint(x: 161.98, y: 5.69), controlPoint1: CGPoint(x: 162.67, y: 13.35), controlPoint2: CGPoint(x: 163.5, y: 9.24))
                path.addCurve(to: CGPoint(x: 153.03, y: 0), controlPoint1: CGPoint(x: 160.47, y: 2.15), controlPoint2: CGPoint(x: 156.91, y: -0.11))
                path.addLine(to: CGPoint(x: 153.03, y: 0.01))
                path.close()
                context.saveGState()
                context.translateBy(x: 70.64, y: 95.19)
                path.usesEvenOddFillRule = true
                UIColor.white.setFill()
                path.fill()
                context.restoreGState()

                context.restoreGState()
            }

            context.restoreGState()
        }

        context.restoreGState()
    }

    class func drawError(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 302, height: 302), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 302, height: 302), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 302, y: resizedFrame.height / 302)

        /// error
        do {
            context.saveGState()

            /// Shape
            let shape = UIBezierPath()
            shape.move(to: CGPoint(x: 151, y: 302))
            shape.addCurve(to: CGPoint(x: 0, y: 151), controlPoint1: CGPoint(x: 67.74, y: 302), controlPoint2: CGPoint(x: 0, y: 234.26))
            shape.addCurve(to: CGPoint(x: 151, y: 0), controlPoint1: CGPoint(x: 0, y: 67.74), controlPoint2: CGPoint(x: 67.74, y: 0))
            shape.addCurve(to: CGPoint(x: 302, y: 151), controlPoint1: CGPoint(x: 234.26, y: 0), controlPoint2: CGPoint(x: 302, y: 67.74))
            shape.addCurve(to: CGPoint(x: 151, y: 302), controlPoint1: CGPoint(x: 302, y: 234.26), controlPoint2: CGPoint(x: 234.26, y: 302))
            shape.close()
            shape.move(to: CGPoint(x: 151, y: 17.76))
            shape.addCurve(to: CGPoint(x: 17.76, y: 151), controlPoint1: CGPoint(x: 77.52, y: 17.76), controlPoint2: CGPoint(x: 17.76, y: 77.52))
            shape.addCurve(to: CGPoint(x: 151, y: 284.24), controlPoint1: CGPoint(x: 17.76, y: 224.48), controlPoint2: CGPoint(x: 77.52, y: 284.24))
            shape.addCurve(to: CGPoint(x: 284.24, y: 151), controlPoint1: CGPoint(x: 224.48, y: 284.24), controlPoint2: CGPoint(x: 284.24, y: 224.48))
            shape.addCurve(to: CGPoint(x: 151, y: 17.76), controlPoint1: CGPoint(x: 284.24, y: 77.52), controlPoint2: CGPoint(x: 224.48, y: 17.76))
            shape.close()
            context.saveGState()
            UIColor.white.setFill()
            shape.fill()
            context.restoreGState()

            /// Path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 102.24, y: 88.96))
            path.addCurve(to: CGPoint(x: 102.22, y: 102.26), controlPoint1: CGPoint(x: 105.92, y: 92.63), controlPoint2: CGPoint(x: 105.92, y: 98.59))
            path.addLine(to: CGPoint(x: 102.22, y: 102.26))
            path.addCurve(to: CGPoint(x: 88.89, y: 102.24), controlPoint1: CGPoint(x: 98.55, y: 105.93), controlPoint2: CGPoint(x: 92.57, y: 105.91))
            path.addLine(to: CGPoint(x: 2.76, y: 16.05))
            path.addCurve(to: CGPoint(x: 2.78, y: 2.73), controlPoint1: CGPoint(x: -0.92, y: 12.36), controlPoint2: CGPoint(x: -0.92, y: 6.42))
            path.addLine(to: CGPoint(x: 2.78, y: 2.73))
            path.addCurve(to: CGPoint(x: 16.11, y: 2.77), controlPoint1: CGPoint(x: 6.47, y: -0.92), controlPoint2: CGPoint(x: 12.43, y: -0.92))
            path.addLine(to: CGPoint(x: 102.24, y: 88.96))
            path.close()
            context.saveGState()
            context.translateBy(x: 99, y: 99)
            UIColor.white.setFill()
            path.fill()
            context.restoreGState()

            /// Path
            let path2 = UIBezierPath()
            path2.move(to: CGPoint(x: 2.76, y: 88.96))
            path2.addCurve(to: CGPoint(x: 2.78, y: 102.26), controlPoint1: CGPoint(x: -0.92, y: 92.63), controlPoint2: CGPoint(x: -0.92, y: 98.59))
            path2.addLine(to: CGPoint(x: 2.78, y: 102.26))
            path2.addCurve(to: CGPoint(x: 16.11, y: 102.24), controlPoint1: CGPoint(x: 6.45, y: 105.93), controlPoint2: CGPoint(x: 12.44, y: 105.91))
            path2.addLine(to: CGPoint(x: 102.24, y: 16.03))
            path2.addCurve(to: CGPoint(x: 102.22, y: 2.72), controlPoint1: CGPoint(x: 105.92, y: 12.35), controlPoint2: CGPoint(x: 105.92, y: 6.4))
            path2.addLine(to: CGPoint(x: 102.22, y: 2.72))
            path2.addCurve(to: CGPoint(x: 88.9, y: 2.77), controlPoint1: CGPoint(x: 98.53, y: -0.91), controlPoint2: CGPoint(x: 92.58, y: -0.91))
            path2.addLine(to: CGPoint(x: 2.76, y: 88.96))
            path2.close()
            context.saveGState()
            context.translateBy(x: 99, y: 99)
            UIColor.white.setFill()
            path2.fill()
            context.restoreGState()

            context.restoreGState()
        }

        context.restoreGState()
    }

    class func drawWarning(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 327, height: 302), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 327, height: 302), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 327, y: resizedFrame.height / 302)

        /// warning
        do {
            context.saveGState()

            /// Shape
            let shape = UIBezierPath()
            shape.move(to: CGPoint(x: 46.99, y: 302))
            shape.addLine(to: CGPoint(x: 280.19, y: 302))
            shape.addCurve(to: CGPoint(x: 319.42, y: 234.89), controlPoint1: CGPoint(x: 319.86, y: 302), controlPoint2: CGPoint(x: 338.6, y: 269.32))
            shape.addLine(to: CGPoint(x: 201.73, y: 26.15))
            shape.addCurve(to: CGPoint(x: 125.02, y: 26.15), controlPoint1: CGPoint(x: 182.12, y: -8.72), controlPoint2: CGPoint(x: 144.63, y: -8.72))
            shape.addLine(to: CGPoint(x: 7.76, y: 234.89))
            shape.addCurve(to: CGPoint(x: 46.99, y: 302), controlPoint1: CGPoint(x: -11.85, y: 269.75), controlPoint2: CGPoint(x: 7.33, y: 302))
            shape.close()
            shape.move(to: CGPoint(x: 36.1, y: 251.01))
            shape.addLine(to: CGPoint(x: 153.35, y: 42.27))
            shape.addCurve(to: CGPoint(x: 172.97, y: 42.27), controlPoint1: CGPoint(x: 159.02, y: 32.25), controlPoint2: CGPoint(x: 165.99, y: 29.63))
            shape.addLine(to: CGPoint(x: 290.66, y: 251.01))
            shape.addCurve(to: CGPoint(x: 279.76, y: 269.32), controlPoint1: CGPoint(x: 297.63, y: 263.65), controlPoint2: CGPoint(x: 290.66, y: 269.32))
            shape.addLine(to: CGPoint(x: 46.99, y: 269.32))
            shape.addCurve(to: CGPoint(x: 36.1, y: 251.01), controlPoint1: CGPoint(x: 32.17, y: 269.32), controlPoint2: CGPoint(x: 30.43, y: 261.91))
            shape.close()
            context.saveGState()
            UIColor.white.setFill()
            shape.fill()
            context.restoreGState()

            /// Path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 8.53, y: 114))
            path.addLine(to: CGPoint(x: 23.47, y: 114))
            path.addCurve(to: CGPoint(x: 32, y: 105.3), controlPoint1: CGPoint(x: 28.16, y: 114), controlPoint2: CGPoint(x: 32, y: 110.08))
            path.addLine(to: CGPoint(x: 32, y: 13.05))
            path.addCurve(to: CGPoint(x: 19.2, y: 0), controlPoint1: CGPoint(x: 32, y: 5.66), controlPoint2: CGPoint(x: 26.45, y: 0))
            path.addLine(to: CGPoint(x: 12.8, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: 13.05), controlPoint1: CGPoint(x: 5.55, y: 0), controlPoint2: CGPoint(x: 0, y: 5.66))
            path.addLine(to: CGPoint(x: 0, y: 105.73))
            path.addCurve(to: CGPoint(x: 8.53, y: 114), controlPoint1: CGPoint(x: 0, y: 110.52), controlPoint2: CGPoint(x: 3.84, y: 114))
            path.close()
            context.saveGState()
            context.translateBy(x: 146, y: 89)
            UIColor.white.setFill()
            path.fill()
            context.restoreGState()

            /// Oval
            let oval = UIBezierPath()
            oval.move(to: CGPoint(x: 16, y: 32))
            oval.addCurve(to: CGPoint(x: 32, y: 16), controlPoint1: CGPoint(x: 24.84, y: 32), controlPoint2: CGPoint(x: 32, y: 24.84))
            oval.addCurve(to: CGPoint(x: 16, y: 0), controlPoint1: CGPoint(x: 32, y: 7.16), controlPoint2: CGPoint(x: 24.84, y: 0))
            oval.addCurve(to: CGPoint(x: 0, y: 16), controlPoint1: CGPoint(x: 7.16, y: 0), controlPoint2: CGPoint(x: 0, y: 7.16))
            oval.addCurve(to: CGPoint(x: 16, y: 32), controlPoint1: CGPoint(x: 0, y: 24.84), controlPoint2: CGPoint(x: 7.16, y: 32))
            oval.close()
            context.saveGState()
            context.translateBy(x: 146, y: 220)
            UIColor.white.setFill()
            oval.fill()
            context.restoreGState()

            context.restoreGState()
        }

        context.restoreGState()
    }


    //MARK: - Canvas Images

    /// Page 1

    class func imageOfInfo() -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 302), false, 0)
        Icons.drawInfo()
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        return image
    }

    class func imageOfSuccess() -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 304, height: 302), false, 0)
        Icons.drawSuccess()
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        return image
    }

    class func imageOfError() -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 302, height: 302), false, 0)
        Icons.drawError()
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        return image
    }

    class func imageOfWarning() -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 327, height: 302), false, 0)
        Icons.drawWarning()
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        return image
    }


    //MARK: - Resizing Behavior

    enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }


}
