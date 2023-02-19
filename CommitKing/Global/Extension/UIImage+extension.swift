//
//  UIImage+extension.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/18.
//

import UIKit

extension UIImage {
    // https://nsios.tistory.com/154
    // 도입 보류. 메모리 용량과 관련해서 기술적 해결을 한 경험을로 넣어야 함
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }
    func downSampling(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
      let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
      let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!

      let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
      let downSamplingOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
      ] as CFDictionary

      let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSamplingOptions)!

      return UIImage(cgImage: downSampledImage)
    }
}
