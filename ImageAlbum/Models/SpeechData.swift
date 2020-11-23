//
//  SpeechData.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/23.
//

import Foundation

final class SpeechData: ObservableObject {
  // 回転フラグ
  @Published var isRotation = false
  
  // 音声認識クラス
  private var speech: SpeechRecognizer = SpeechRecognizer()
  
  // 許可ダイアログ
  func authorization() {
    self.speech.authorization()
  }
  
  // 音声認識を開始
  func start() {
    
    do {
      // 音声認識を開始
      try self.speech.start() {
        // 循環参照させないために弱参照を宣言
        [weak self] (isRotation: Bool) -> Void in
        
        // エラー判定
        guard let self = self else {
          return
        }
        
        // 回転フラグを設定
        if self.isRotation != isRotation {
          self.isRotation = isRotation
        }
      }
    } catch {
      // エラー発生
      print("音声認識の例外エラー")
    }
  }
  // 音声認識を停止
  func stop() {
    self.speech.stop()
    self.isRotation = false
  }
}
