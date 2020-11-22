//
//  AlbumView.swift
//  TechImage
//
//  Created by Takuya Ando on 2020/11/12.
//

import SwiftUI

struct AlbumView: View {
  
  @EnvironmentObject private var userData: UserData
  
  let name: String
  let path: String
  let isFavorite: Bool
  
  // イニシャライザは実行時に自動的に定義される。内容把握のためにあえて書く
  init(name: String, path: String, isFavorite: Bool) {
    self.name = name
    self.path = path
    self.isFavorite = isFavorite
  }
    
  var body: some View {
    // ビューを縦に並べ、左端に揃える
    VStack(alignment: .leading) {
      // ビューを重ねて表示
      ZStack {
        // ビューをグループ化
        Group {
          // 画像のファイルパスが設定されている場合
          if self.path.count > 0 {
            
            // プロパティ値であるself.pathで画像のファイルパスを設定
            Image(uiImage: UIImage.init(contentsOfFile: self.path)!)
              // オリジナル画像を表示
              .renderingMode(.original)
              // 横幅、高さ、表示位置
              .frame(width: 100, height: 100, alignment: .center)
          }
          else {
            // iOSで使用できるシステムアイコン（四角）を表示
            Image(systemName: "square.on.square")
              .renderingMode(.original)
              .frame(width: 100, height: 100, alignment: .center)
          }
          // お気に入りの場合
          if self.isFavorite == true {
            // ハートを表示
            Image(systemName: "heart.fill")
              // 左下に表示
              .frame(width: 100, height: 100, alignment: .bottomLeading)
              // ピンク
              .foregroundColor(.pink)
          }
        }
        // グループ内の要素（ビュー）に余白を追加
        .padding()
        .border(Color.gray, width: 1) // 枠線をグレーに設定
      }
      // ZStack内のビューを角丸
      .cornerRadius(10)
      
      // 名称
      Text(self.name)
        .foregroundColor(.primary)
      
      // 画像数
      Group {
        if self.isFavorite == true {
          Text(String(countFavorite(images: self.userData.images)))
        }
        else {
          // 配列のcountで画像数を文字列変換して表示
          Text(String(self.userData.images.count))
        }
      }
      .foregroundColor(.primary)
    }
  }
}

struct AlbumView_Previews: PreviewProvider {
  static var previews: some View {
    // プレビュー画面で表示するためにenviromentObjectを追加
    AlbumView(name: "お気に入り",
              path: "",
              isFavorite: true).environmentObject(UserData())
  }
}

