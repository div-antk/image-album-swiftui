//
//  Supportin Views.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import SwiftUI

// 画像リストの行
struct ImageListView: View {
  
  @EnvironmentObject private var userData: UserData
  
  // self.userData.images配列の番号
  let id: Int
  
  var body: some View {
    
    // ビューを横に並べて表示
    HStack {
      
      // 画像情報が1つでも存在する場合、画像、ファイル名、余白、ハートの順で横に並べて表示
      if self.userData.images.count > 0 {
        
        // ファイルパスを設定して画像を取得
        Image(uiImage: UIImage.init(contentsOfFile: self.userData.images[self.id].path)!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50, alignment: .center)
        
        // ファイル名称
        Text(self.userData.images[self.id].name)
        
        // 画面いっぱいまで余白を追加
        Spacer()
        
        // ハート画像をGroupで囲む。Groupで囲んだビューにはまとめて同じ処理を追加できる
        Group {
          
          // お気に入りの場合
          if self.userData.images[self.id].isFavorite {
            
            // 色付きのハート
            Image(systemName: "heart.fill")
              .foregroundColor(Color.pink)
          } else {
            // 色なしハート
            Image(systemName: "heart")
              .foregroundColor(Color.gray)
          }
        }
        
        // ハート画像がタップされた場合
        .onTapGesture {
          
          // お気に入り値の反転
          self.userData.images[self.id].isFavorite.toggle()
          
          // お気に入りの保存
          saveFavorite(name: self.userData.images[self.id].name,
                       isFavorite: self.userData.images[self.id].isFavorite)
        }
      } else {
        // 画像情報がない場合、Noneを表示
        Text("None" )
      }
    }
  }
}

struct ImageListView_Previews: PreviewProvider {
  static var previews: some View {
    ImageListView(id: 0).environmentObject(UserData())
  }
}

