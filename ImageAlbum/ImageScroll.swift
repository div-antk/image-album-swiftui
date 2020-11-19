//
//  ImageScroll.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/17.
//

import SwiftUI

struct KindStructImage {
  static let regular: Int = 0 // 初期値。何もしない
  static let grayscale: Int = 1 // グレースケール
  static let colorInvert: Int = 2 // 色調反転
  static let sepia: Int = 3 // セピア
  
}

struct ImageScroll: View {
  // 画像情報を使用
  @EnvironmentObject private var userData: UserData
  
  // 編集モードの状態（編集:active 完了:inactive）初期値は完了状態
  @State private var isEditMode: EditMode = .inactive
  
  // 画像処理の種別
  @State private var kindImage: Int = KindStructImage.regular
  
  // お気に入りのみ表示するかの判定
  var onlyFavorite: Bool
  
  var body: some View {
    
    // GeometryReader{} で親（body全体）のビューのサイズや位置、セーフエリア外マージンなどを取得できる
    GeometryReader { geometry in
      
      // スクロールバーの上にツールバー（下）を重ねて表示
      ZStack(alignment: .bottom) {
        
        // スクロール表示する
        ScrollView(.vertical, showsIndicators: true) {
          
          // 縦に表示
          VStack(alignment: .leading, spacing: 0) {
            
            // 画像情報からすべての画像を取得する
            ForEach(self.userData.images) { item in
              
              // お気に入りのみ表示、もしくはすべての項目を表示する
              if (self.onlyFavorite == true && item.isFavorite) || self.onlyFavorite == false {
                
                // 画像の縦横比を維持したままリサイズを表示する
                Image(uiImage: UIImage.init(contentsOfFile: item.path)!)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              }
            }
          }
        }
        // 編集状態の場合ツールバーを表示
        if self.isEditMode == .active {
          
          // ビューを横に並べて表示する（ツールバー）
          HStack {
            
            // 写真アイコンを表示（グレースケールボタン）
            Image(systemName: "photo")
              
              // グレー表示
              .foregroundColor(Color.gray)
              
              // グレースケール画像がタップされた場合実行される
              .onTapGesture {
                
                // グレースケール状態に変更
                self.kindImage = KindStructImage.grayscale
              }
            // 余白を追加する
            Spacer()
            
            // 色調反転ボタン
            Button(action: {
              // 色調反転状態に変更する
              self.kindImage = KindStructImage.colorInvert
            }) {
              // 写真アイコン（塗りつぶし）を表示する
              Image(systemName: "photo.fill")
                
                // ブルーを表示
                .foregroundColor(Color.blue)
            }
            Spacer()
            
            // セピアボタン
            Button(action: {
              self.kindImage = KindStructImage.sepia
            }) {
              // 写真アイコン2枚を表示する
              Image(systemName: "photo.on.rectangle")
                
                // イエローを表示
                .foregroundColor(Color.yellow)
            }
          }
          // アイコンとツールバーの間に余白を追加
          .padding()
          
          // ツールバーの高さとアイコンの表示位置を設定
          .frame(height: 44+geometry.safeAreaInsets.bottom, alignment: .top)
          
          // ツールバーの背景色を白に設定
          .background(Color.white)
        }
      }
      // スクロールビューの高さを設定する
      .frame(maxHeight: .infinity)
      // タイトル
      .navigationBarTitle(Text("画像スクロール"))
      
      // 下側のセーフエリアを無視
      .edgesIgnoringSafeArea(.bottom)
      
      // ナビゲーションバー右側に編集ボタンを追加
      .navigationBarItems(trailing: EditButton())
      
      // 編集モードを渡す
      .environment(\.editMode, self.$isEditMode)
    }
  }
}

struct ImageScroll_Previews: PreviewProvider {
  static var previews: some View {
    ImageScroll(onlyFavorite: false).environmentObject(UserData())
  }
}
