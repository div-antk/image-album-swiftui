//
//  ImageData.swift
//  TechImage
//
//  Created by Takuya Ando on 2020/11/14.
//

// 画像情報の取得

import Foundation

// 画像情報の構造体
struct ImageInfo: Identifiable {
  let id: Int // Identifiableに必要
  let name: String // ファイル名称
  var path: String // ファイルパス
  var isFavorite: Bool // お気に入り
}

// 画像情報を配列で保持
let imageInfos: [ImageInfo] = loadImageInfos()

// ~/Documentsフォルダ内の画像ファイルをすべて取得する
func loadImageInfos() -> Array<ImageInfo> {
  // ~/Documentsフォルダ内の画像ファイルをすべて取得する
  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                          .userDomainMask,
                                                          true)[0]
  // ファイルがひとつも存在しない場合は空配列を取得
  guard var fileNames = try? FileManager.default.contentsOfDirectory(atPath: documentsPath) else {
    return[]
  }
  
  // ファイル名称を昇順で並び替え
  fileNames.sort { $0 < $1 }
  
  // お気に入り情報を取得する
  let favoriteArray: Array<String> = [] // 後で変更。現在は空配列を代入
  
  // 画像情報の構造体に設定する
  var imageInfos: Array<ImageInfo> = []
  
  // すべてのファイル情報を配列に設定する
  var idNum = 0
  for name: String in fileNames {
    
    // お気に入りかどうか判定
    var isFavorite = false
    if favoriteArray.contains(name) == true {
      isFavorite = true
    }
    
    // Documentsフォルダパスにファイル名称を追加してファイルパスを作成
    let path = documentsPath + "/" + name
    
    // 構造体を作成
    let imageInfo = ImageInfo(id: idNum,
                              name: name,
                              path: path,
                              isFavorite: isFavorite)
    
    // 配列に追加
    imageInfos.append(imageInfo)
    
    // ファイルごとに異なるidを割り振るために1ずつ増やす
    idNum += 1
  }
  return imageInfos
}
