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
  
  // セピア（クラスメソッド）
  class func sepia(path: String) -> UIImage {
    
    // セピアメソッドに渡されたURLからCIImageを作成
    let ciImageWrap: CIImage? = CIImage(contentsOf: URL(fileURLWithPath: path))
    
    guard let ciImage = ciImageWrap else {
      return UIImage.init()
    }
    
    // CIFiterでセピア設定
    let ciFilterWrap: CIFilter? = CIFilter(name: "CISepiaTone")
    
    guard let ciFilter = ciFilterWrap else {
      return UIImage.init()
      
    }
    
    // kCIInputImageKeyでフィルターをかける処理をciImageに設定
    ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
    // inputIntensityでセピア処理にかける度合いを1.0に設定
    ciFilter.setValue(1.0, forKey: "inputIntensity")
    
    // CIImageでセピア画像作成
    let sepiaCIImageWrap: CIImage? = ciFilter.outputImage
    
    guard let sepiaCIImage = sepiaCIImageWrap else {
      return UIImage.init()
    }
    
    // CIImage -> CGImage
    let ciContext: CIContext = CIContext(options: nil)
    let cgImageWrap: CGImage? = ciContext.createCGImage(sepiaCIImage,
                                                        from: sepiaCIImage.extent)
    
    guard let cgImage = cgImageWrap else {
      return UIImage.init()
    }
    
    // CGImageをビューで表示できるUIImageに変換
    let sepiaImageWrap: UIImage? = UIImage(cgImage: cgImage, scale: 0.0,
                                           orientation: UIImage.Orientation.up)
    
    guard let sepiaImage = sepiaImageWrap else {
      return UIImage.init()
    }
    return sepiaImage
  }
}
