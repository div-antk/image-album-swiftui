//
//  ImageList.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import SwiftUI

struct ImageList: View {
  
  @EnvironmentObject private var userData: UserData
  
  // お気に入り判定
  var onlyFavorite: Bool
  
  var body: some View {
    // 画像リストを表示
    List {
      // 画像情報配列の数分リストを表示
      ForEach (self.userData.images) { item in
        
        // お気に入りのみ表示、もしくはすべての項目を表示
        if (self.onlyFavorite == true &&
              item.isFavorite) ||
            self.onlyFavorite == false {
          
          // NavigationLinkを追加し、ImageScrollを表示させる
          NavigationLink(destination: ImageScroll(onlyFavorite: self.onlyFavorite)) {
            ImageListView(id: item.id)
          }
        }
      }
    }
    .navigationBarTitle(Text("画像リスト"))
  }
}

struct ImageList_Previews: PreviewProvider {
  static var previews: some View {
    // プレビュー機能のためenviromentObjectを追加する
    ImageList(onlyFavorite: false).environmentObject(UserData())
  }
}

