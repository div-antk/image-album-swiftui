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
  private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
  
  // 音声認識タスクを生成
  private var speechTask: SFSpeechRecognitionTask?
  
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

  // 音声認識を開始する
  func start(completion: @escaping (Bool) -> Void) throws {
    
    // 音声認識タスクがすでに開始している場合キャンセルする
    if let speechTask = speechTask {
      speechTask.cancel()
      self.speechTask = nil
    }
    
    // 音声認識
    
    // 音声バッファを音声認識に渡す機能
    self.speechRequest = SFSpeechAudioBufferRecognitionRequest()
    
    // 音声認識タスク
    self.speechTask = self.speechRecognizer.recognitionTask(with: self.speechRequest!) {
      [weak self](result, error) in
      
      // エラー判定
      guard let self = self else {
        return
      }
      
      // 完了フラグ
      var isFinal = false
      
      // 音声認識の結果がある場合
      if let result = result {
        
        // 最新の結果を取得する
        let seg = result.bestTranscription.segments.last
        
        // デバッグログに音声認識結果を表示する
        print(seg!.substring)
        
        // 回れと認識した場合
        if seg!.substring == "回れ" {
          // クロージャにして音声認識フラグをtrueにする
          completion(true)
        }
        // 完了フラグ
        isFinal = result.isFinal
      }
      // エラー、もしくは完了
      if error != nil || isFinal {
        
        // 音声認識を終了する
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.speechRequest = nil
        self.speechTask = nil
      }
    }
    // -- 音管理（マイク） --
    
    // 音の出力フォーマットを取得する
    let recordFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
    
    // 前回実行時に監視していたバスを削除する
    self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordFormat) {
      [weak self](buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      
      // エラー判定
      guard let self = self else {
        return
      }
      // 音声バッファを追加
      self.speechRequest?.append(buffer)
    }
    // マイク音取得を開始
    self.audioEngine.prepare()
    try? self.audioEngine.start()
  }
  // 音声認識を停止する
  func stop() {
    self.audioEngine.stop()
    self.speechRequest?.endAudio()
    self.speechTask?.cancel()
    self.speechRequest = nil
    self.speechTask = nil
  }
}
