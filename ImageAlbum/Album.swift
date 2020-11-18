//
//  Album.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import SwiftUI

struct Album: View {
  
  @EnvironmentObject private var userData: UserData
  
  var body: some View {
    
    NavigationView {
      VStack {
        // ナビゲーションリンクを追加する
        NavigationLink(destination: ImageList(onlyFavorite: false)) {
          // pathに画像ファイルパスを設定する。画像がない場合は空文字
          AlbumView(name: "すべての項目",
                    path: self.userData.images.count > 0 ? self.userData.images[0].path : "",
                    isFavorite: false)
        }
        // ナビゲーションリンクを追加する
        NavigationLink(destination: ImageList(onlyFavorite: true)) {
          AlbumView(name: "お気に入り",
                    path: self.userData.images.count > 1 ? self.userData.images[1].path : "",
                    isFavorite: true)
        }
      }
      // VStack{}にnavigationBarTitle()を追加
      .navigationBarTitle(Text("アルバム"))
    }
  }
}

struct Album_Previews: PreviewProvider {
  static var previews: some View {
    Album()
  }
}
