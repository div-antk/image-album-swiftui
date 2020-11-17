//
//  ImageScroll.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/17.
//

import SwiftUI

struct ImageScroll: View {
  // 画像情報を使用
  @EnvironmentObject private var userData: UserData
  
  // お気に入りのみ表示するかの判定
  var onlyFavorite: Bool
  
  var body: some View {
    // スクロール表示する
    ScrollView(.vartical, showsIndicators: true) {
      
      // 縦に表示
      VStack(alignment: .leading, spacing: 0) {
        
        // 画像情報からすべての画像を取得する
        ForEach(self.userData.images) { item is
          
          // お気に入りのみ表示、もしくはすべての項目を表示する
          if (self.onlyFavorite == true &&
                item.isFavorite) ||
                self.onlyFavorite == false {
            
            // 画像の縦横比を維持したままリサイズを表示する
            Image(uiImage: UIImage.init(contentsOfFile: item.path)!)
              .resizable()
              .aspectRatio(contentMode: .fit)
          }
        }
      }
    }
    // スクロールビューの高さを設定する
    .frame(maxHeight: .infinity)
    
    // タイトル
    .navigationBarTitle(Text("画像スクロール"))
  }
}

struct ImageScroll_Previews: PreviewProvider {
    static var previews: some View {
      ImageScroll(onlyFavorite: false).environmentObject(UserData())
    }
}
