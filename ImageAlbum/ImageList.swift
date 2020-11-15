//
//  ImageList.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import SwiftUI

struct ImageList: View {
  
  @EnvironmentObject private var userData: UserData
  
  var body: some View {
    // 画像リストを表示
    List {
      // 画像情報配列の数分リストを表示
      ForEach (self.userData.images) { item in
        Text("")
      }
    }
    .navigationBarTitle(Text("画像リスト"))
  }
}

struct ImageList_Previews: PreviewProvider {
  static var previews: some View {
    // プレビュー機能のためenviromentObjectを追加する
    ImageList().environmentObject(UserData())
  }
}
