//
//  UserData.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

/*
 ObservableObject:複数のviewの状態管理をひとまとまりのオブジェクトとして管理する
 @Published:ObservableObjectの監視するプロパティに指定する
 final:継承するのを禁止、サブクラスでオーバーライドされるのを禁止することでデータが変更されないようにする
 */

import Foundation

final class UserData: ObservableObject {
  @Published var images = imageInfos
}
