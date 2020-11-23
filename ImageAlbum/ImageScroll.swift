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
  // EnvironmentObjectは複数のビューに使用する
  @EnvironmentObject private var userData: UserData
  
  // 音声データクラスを生成
  // ObservedObjectは単一のビューに使用する（画像スクロール画面のみ）
  @ObservedObject private var speech: SpeechData = SpeechData()
  
  // 編集モードの状態（編集:active 完了:inactive）初期値は完了状態
  @State private var isEditMode: EditMode = .inactive
  
  // 画像処理の種別
  @State private var kindImage: Int = KindStructImage.regular
  
  // 音声認識フラグ
  @State private var isSpeech: Bool = false
  
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
              if (self.onlyFavorite == true &&
                    item.isFavorite) ||
                  self.onlyFavorite == false {
                
                // グレースケール（CGImageによる画像処理）
                if self.kindImage == KindStructImage.grayscale {
                  Image(uiImage: (UIImage.init(contentsOfFile: item.path)?.grayScale())!)
                    .resizable()
                }
                // 色調反転。縦横比を維持する処理をも追加する（Imageビューのメソッドによるビュー色の変更）
                else if self.kindImage == KindStructImage.colorInvert {
                  Image(uiImage: UIImage.init(contentsOfFile: item.path)!)
                    .resizable()
                    .colorInvert()
                }
                // セピア（CGImageによる画像処理）
                else if self.kindImage == KindStructImage.sepia {
                  Image(uiImage: UIImage.sepia(path: item.path))
                    .resizable()
                }
                // 通常
                else {
                  Image(uiImage: UIImage.init(contentsOfFile: item.path)!)
                    .resizable()
                }
              }
            }
            .aspectRatio(contentMode: .fit)
            
            // 回転アニメーション
            .rotationEffect(.degrees(self.speech.isRotation ? 360 : 0))
            
            // 詳細なアニメーション設定
            .animation(self.speech.isRotation ? self.animation :.none)
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
            
            // 音声認識ボタンをツールバーに追加
            Button(action: {
              
              if self.isSpeech {
                // 音声認識停止
                self.speech.stop()
              
              } else {
                // 音声認識開始
                self.speech.start()
              }
              self.isSpeech.toggle()
            }) {
              // マイク画像
              if self.isSpeech {
                Image(systemName: "mic")
                  .foregroundColor(Color.red)
              } else {
                Image(systemName: "mic")
                  .foregroundColor(Color.green)
              }
            }
            
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
    // 画面表示時に音声認識の許可ダイアログを表示（初回のみ）
    // onAppearは画像スクロール画面が表示されたときに()内の処理を実行
    .onAppear(perform: speechAuthorization)
    
    // 画面表示時に音声認識を停止
    // onDisappearは画像スクロール画面が非表示になると speechStopメソッドを実行
    .onDisappear(perform: speechStop)
  }
  // 詳細なアニメーション設定
  var animation: Animation {
    // アニメーションの初期速度や減衰量を設定
    Animation.interpolatingSpring(
      mass: 1,
      stiffness: 2,
      damping: 0.8,
      initialVelocity: 2
    ) .speed(2)
  }
  
  // 音声認識を停止
  func speechStop() {
    self.speech.stop()
  }
  // 音声認識の許可ダイアログを表示
  func speechAuthorization() {
    self.speech.authorization()
  }
}

struct ImageScroll_Previews: PreviewProvider {
  static var previews: some View {
    ImageScroll(onlyFavorite: false).environmentObject(UserData())
  }
}
