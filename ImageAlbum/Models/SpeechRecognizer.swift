//
//  SpeechRecognizer.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/22.
//

import Foundation
import Speech // 音声認識フレームワーク

//MARK:- Speech

class SpeechRecognizer {
  // 音を管理
  private let audioEngine = AVAudioEngine()
  
  // マイクから取得した音声バッファを音声認識に渡す
  private var speechRequest: SFSpeechAudioBufferRecognitionRequest?
  
  // 音声認識を日本語に設定
  private var speechRecognizer = SFSpeechRecognitionTask?
  
  // ユーザに音声認識の許可を促す
  func authorization() {
    SFSpeechRecognizer.requestAuthorization { (authStatus) in
      
      switch authStatus {
      
      case .authorized:
        // ユーザが許可
        print("許可")
        
      case .denied:
        // ユーザが拒否
        print("拒否")
        
      case .restricted:
        // 音声対応機器に非対応
        print("非対応")
        
      case .notDetermined:
        // ユーザが音声認識をまだ認証していない
        print("未認証")
        
      default:
        print("上記以外")
      }
    }
  }
