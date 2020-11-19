//
//  UIImage+Filter.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/20.
//

import Foundation

import UIKit

//MARK:- UIImage

extension UIImage {
  // グレースケール（インスタンスメソッド）
  func grayScale() -> UIImage {
    
    // グラフィックコンテキスト作成
    guard let context = CGContext(data: nil,
                                  width: Int(self.size.width),
                                  height: Int(self.size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceGray(),
                                  bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
      return UIImage.init()
    }
    
    // CGImage
    guard let originalCGImage = self.cgImage else {
      return UIImage.init()
    }
    // グラフィックコンテキストに画像処理
    context.draw(originalCGImage, in: CGRect(x: 0,
                                             y: 0,
                                             width: self.size.width,
                                             height: self.size.height))
    
    // グラフィックコンテキストからCGImageに変換
    let grayScaleCGImageWrap: CGImage? = context.makeImage()
    
    guard let grayScaleCGImage = grayScaleCGImageWrap else {
      return UIImage.init()
    }
    
    // CGImage -> UIImage
    let grayScaleImageWrap: UIImage? = UIImage(cgImage: grayScaleCGImage)
    
    guard let grayScaleImage = grayScaleImageWrap else {
      return UIImage.init()
    }
    
    return grayScaleImage
  }
  

}
