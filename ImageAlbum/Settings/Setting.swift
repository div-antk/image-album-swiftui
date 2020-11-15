//
//  Setting.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import Foundation

//MARK:- Favorite

struct UserDafaultsKey {
  static let arrayFavorite: String = "arrayFavorite" // お気に入り情報の配列
  static let isApplnit: String = "isApplnit" // 初期化判定
  static let appVersion: String = "appVersion" // アプリバージョン
}

// お気に入り情報の保存
// ファイル名とそのファイルのお気に入りをBoolとして受け取る
func saveFavorite(name: String, isFavorite: Bool) {
  
  // お気に入り情報の取得
  let isFavoriteArrayWrap = UserDefaults.standard.stringArray(forKey: UserDafaultsKey.arrayFavorite)
  
  // お気に入り情報がない場合は何もしない
  // guard文で宣言した isFavoriteArray はスコープ外で使用できる
  guard var isFavoriteArray = isFavoriteArrayWrap else {
    return
  }
  
  // お気に入り
  if isFavorite {
    
    // 追加
    isFavoriteArray.append(name)
  }
  else {
    
    // 削除
    // firstIndexでファイル名を指定すると配列内で最初に検索ヒットした番号を返す
    if let index = isFavoriteArray.firstIndex(of: name) {
      // その番号を使って削除
      isFavoriteArray.remove(at: index)
    }
  }
  // お気に入りを保存
  UserDefaults.standard.set(isFavoriteArray,
                            forKey: UserDafaultsKey.arrayFavorite)
  
  return
}

// お気に入り情報の取得
func loadFavorite() -> Array<String> {
  let isFavoriteArrayWrap = UserDefaults.standard.stringArray(forKey: UserDafaultsKey.arrayFavorite)
  
  // お気に入り情報がない場合
  guard let isFavoriteArray = isFavoriteArrayWrap else {
    return []
  }
  return isFavoriteArray
}

// お気に入りの数を取得
func countFavorite(images: Array<ImageInfo>) -> Int {
  var count = 0
  
  for item in images {
    if item.isFavorite {
      count += 1 // count++はSwiftでは使用できない
    }
  }
  return count
}
