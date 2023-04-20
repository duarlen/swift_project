
import Photos
import UIKit
import Accelerate

public extension UIImage {
    
    /// 生成一张纯色图片
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgImage = image?.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    /// 生成一张渐变色图片
    convenience init(colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), start: CGPoint = CGPoint(x: 0.5, y: 0), end: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let colors = colors.map{$0.cgColor } as CFArray
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let cs = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: cs, colors: colors, locations: nil)
        let ctx = UIGraphicsGetCurrentContext()
        if let ctx = ctx, let gradient = gradient {
            let startPoint = CGPoint(x: start.x * size.width, y: start.y * size.height)
            let endPoint = CGPoint(x: end.x * size.width, y: end.y * size.height)
            ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        }
        let cgImage = ctx?.makeImage()
        UIGraphicsEndImageContext()
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    /// 根据视频链接获取第 N 帧的截
    convenience init?(url: URL, time: TimeInterval) {
        let asset = AVURLAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels
        if let thumb = try? assetImageGenerator.copyCGImage(at: CMTime(value: CMTimeValue(time), timescale: 60), actualTime: nil) {
            self.init(cgImage: thumb)
        } else {
            self.init()
        }
    }
    
    /// 将图片保存到相册
    func saveToAlbum(_ completionHandler: ((Bool, Error?) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        }, completionHandler: completionHandler)
    }

    // 把一张图片进行指定拉伸
    func stretchableImage(x: CGFloat = 0.5, y: CGFloat = 0.5) -> UIImage {
        return stretchableImage(withLeftCapWidth: Int(size.width * x), topCapHeight: Int(size.height * y))
    }
    
    // 图片添加模糊效果
    func blur(blur: CGFloat) -> UIImage? {
        guard let cgImage = cgImage, let filter = CIFilter(name: "CIGaussianBlur") else { return self }
        let context = CIContext(options: nil)
        let image = CIImage(cgImage: cgImage)
        filter.setValue(image, forKey: "inputImage")
        filter.setValue(blur * 60, forKey: "inputRadius")
        if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: CGRect(origin: .zero, size: self.size)) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    // 根据图片和颜色返回一张加深颜色以后的图片
    func tint(color: UIColor) -> UIImage? {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            let width = size.width * 2
            let height = size.height * 2
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }
            let area = CGRect(x: 0, y: 0, width: width, height: height)
            ctx.scaleBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -area.size.height)
            ctx.saveGState()
            ctx.clip(to: area, mask: cgImage)
            color.set()
            ctx.fill(area)
            ctx.restoreGState()
            ctx.setBlendMode(.multiply)
            ctx.draw(cgImage, in: area)
            let targetImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return targetImage
        }
    }

    /// 修改图片颜色
    func change(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        color.setFill()
        let rect = CGRect(origin: .zero, size: self.size)
        UIRectFill(rect)
        draw(in: rect, blendMode: .overlay, alpha: 1)
        draw(in: rect, blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 裁剪中间的正方形图片
    func clipRect() -> UIImage? {
        if let cgImage = cgImage {
            let width = size.width * scale
            let height = size.height * scale
            let targetWidth = min(width, height)
            let x = (width - targetWidth)/2
            let y = (height - targetWidth)/2
            if let targetCgImage = cgImage.cropping(to: CGRect(x: x, y: y, width: targetWidth/scale, height: targetWidth/scale)) {
                return UIImage(cgImage: targetCgImage)
            }
        }
        return nil
    }
    
    /// 裁剪中间的圆形
    func clipRound() -> UIImage? {
        guard let image = clipRect() else { return nil }
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0);
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: image.size))
        path.addClip()
        image.draw(at: .zero)
        let target = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return target
    }
    
    // 将图片压缩
    func compression(limitSize: Int64) -> UIImage? {
        if let data =  jpegData(compressionQuality: 1), data.count <= limitSize { return nil }
        
        var compress = 0.9
        let maxCompress = 0.1
        var imageData: Data?
        while compress > maxCompress {
            compress = compress - 0.01
            if let data = jpegData(compressionQuality: compress) {
                if data.count > limitSize {
                    compress = compress - 0.1
                } else {
                    imageData = data
                    break
                }
            } else {
                break
            }
        }
        
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
