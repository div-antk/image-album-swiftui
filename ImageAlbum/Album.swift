//
//  Album.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import SwiftUI

struct Album: View {
  var body: some View {
    
    NavigationView {
      VStack {
        AlbumView(name: "すべての項目",
                  path: "",
                  isFavorite: false)
        AlbumView(name: "お気に入り",
                  path: "",
                  isFavorite: true)
      }
      // VStack{}にnavigationBarTitle()を追加
      .navigationTitle(Text("アルバム"))
    }
  }
}

struct Album_Previews: PreviewProvider {
  static var previews: some View {
    Album()
  }
}
