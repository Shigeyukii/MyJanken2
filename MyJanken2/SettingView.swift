//
//  SettingView.swift
//  MyJanken2
//
//  Created by user on 2024/07/15.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("win_value") var win: Int = 0
    @AppStorage("lose_value") var lose: Int = 0
    @AppStorage("draw_value") var draw: Int = 0
    
    var body: some View {
        Button {
            print("win=\(win), lose=\(lose), draw=\(draw)")
            win = 0
            lose = 0
            draw = 0
        } label: {
            Text("勝敗をクリア")
        }
        .font(.title)
        
        Button {
            var csv = ""
            var line = ""

            // CSVに勝ち、負け、あいこの数を書き出す
            line += String(win) + ","
            line += String(lose) + ","
            line += String(draw) + "\r\n"
            csv = line + csv
            
            csv = "かち,まけ,あいこ\r\n" + csv
            //print("\(csv)")
            
            let tmpFile: URL = URL(fileURLWithPath: "data.csv", relativeTo: FileManager.default.temporaryDirectory)
            if let strm = OutputStream(url: tmpFile, append: false) {
                strm.open()
                let BOM = "\u{feff}"
                strm.write(BOM, maxLength: 3)// UTF-8 の BOM 3バイト 0xEF 0xBB 0xBF 書き込み)
                let data = csv.data(using: .utf8)
                // string.data(using: .utf8)メソッドで文字コード UTF-8 の
                // Data 構造体を得る
                _ = data?.withUnsafeBytes {//dataのバッファに直接アクセス
                    strm.write($0.baseAddress!, maxLength: Int(data?.count ?? 0))
                    // 【$0】
                    // 連続したメモリ領域を指す UnsafeRawBufferPointer パラメーター
                    // 【$0.baseAddress】
                    // バッファへの最初のバイトへのポインタ
                    // 【maxLength:】
                    // 書き込むバイトdataバッファのバイト数（全長）
                    // 【data?.count ?? 0】
                    // ?? は、Nil結合演算子（Nil-Coalescing Operator）。
                    // data?.count が nil の場合、0。
                    // 【_ = data】
                    // 戻り値を利用しないため、_で受け取る。
                }
                strm.close() // ストリームクローズ
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {//念の為若干遅らせて、0.001秒後に実行(意味無いかも)
                // DispatchQueue.main.asyncAfter(deadline: .now() + 秒) { 遅延実行したい処理 }
                shareApp(shareText: csv, shareLink: tmpFile.absoluteURL  )
                // tmpFile.absoluteURL = テンポラリファイルの絶対パス（URL型）
            }
        } label: {
            Label(String("CSV出力"), systemImage:  "square.and.arrow.up")
                .font(.title)
                .padding()
        }
        .font(.title)
    }
}

private func shareApp(shareText: String, shareLink: URL ) {
    let items = [shareLink] as [Any]// shareLink = テンポラリファイルの絶対パス（URL型）
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    // UIActivityViewController：共有の時に画面外からフェードインしてくる画面。シェアシート。
    // activityItems：UIImage(画像）、URL（URL）、String（テキスト）など保存したいものを指定
    // applicationActivities：シェアシートをカスタマイズしたい時に使う。デフォルトで良い場合は、nil。
    if UIDevice.current.userInterfaceIdiom == .pad {// デバイスがiPadだったら
        let deviceSize = UIScreen.main.bounds// 画面サイズ取得
        if let popPC = activityVC.popoverPresentationController {
            // ポップオーバーの設定
            // iPadの場合、sourceView、sourceRectを指定しないとクラッシュする。
            popPC.sourceView = activityVC.view // sourceRectの基準になるView
            popPC.barButtonItem = .none// ボタンの位置起点ではない
            popPC.sourceRect = CGRect(x:deviceSize.size.width/2, y: deviceSize.size.height, width: 0, height: 0)// Popover表示起点
        }
    }
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    // UIWindowScene のインスタンス作成
    // 【UIApplication】
    // アプリケーションを制御、管理するクラス
    // 【.shared】
    // シングルトンのUIApplicationインスタンスにアクセス
    // 【.connectedScenes】
    //  アクティブになっているシーンにアクセス（Set<UIScene>）
    // 【.first as? UIWindowScene】
    // マルチウィンドウでは無いため、単純に一番最初の要素にアクセスして、UIWindowScene にキャスト
    let rootVC = windowScene?.windows.first?.rootViewController
    // rootVC　＝　rootViewController：アプリ初期画面（大元のViewController）
    rootVC?.present(activityVC, animated: true,completion: {})
    // アニメーション有りでシェアシート（activityVC）表示（present）
}

#Preview {
    SettingView()
}
