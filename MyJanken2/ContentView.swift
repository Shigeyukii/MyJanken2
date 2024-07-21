//
//  ContentView.swift
//  MyJanken2
//
//  Created by user on 2024/07/06.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("win_value") var win: Int = 0
    @AppStorage("lose_value") var lose: Int = 0
    @AppStorage("draw_value") var draw: Int = 0
    
    // JankenNumber
    //  1: グー
    //  2: チョキ
    //  3: パー
    @State var pcJankenNumber = 0
    @State var myJankenNumber = 0

    // TimeHandler
    //@State var timerHandler: Timer?
    
    @State var buttonFlag = true
    @State var message: String = "Let's Start"
    
    @State var useGu = false
    @State var useChoki = false
    @State var usePa = false
    
    var body: some View {
        
        //let soundPlayer = SoundPlayer()

        NavigationStack {
            VStack {
                
                if win == 0 && lose == 0 && draw == 0 {
                    Text("じゃんけんゲーム")
                        .font(.title)
                        .padding()
                } else {
                    Text("\(win)勝 \(lose)負\(draw)分け")
                        .font(.title)
                        .padding()
                        .frame(height: 100)
                    
                }
                
                Spacer()
                
                ZStack {
                    if message == "ぽん" || message == "かち" || message == "まけ" || message == "あいこ" {
                        if pcJankenNumber == 1 {
                            Image(.gu)
                                .resizable()
                                .scaledToFit()
                                .rotation3DEffect(.degrees(180),
                                                  axis: (x: 1, y: 0, z: 0))
                                .padding()
                        } else if pcJankenNumber == 2 {
                            Image(.choki)
                                .resizable()
                                .scaledToFit()
                                .rotation3DEffect(.degrees(180),
                                                  axis: (x: 1, y: 0, z: 0))
                                .padding()
                        } else if pcJankenNumber == 3 {
                            Image(.pa)
                                .resizable()
                                .scaledToFit()
                                .rotation3DEffect(.degrees(180),
                                                  axis: (x: 1, y: 0, z: 0))
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                Text("Computer")
                
                Spacer()
                
                if buttonFlag {
                    
                    Button {
                        
                        buttonFlag = false
                        useGu = false
                        useChoki = false
                        usePa = false
                        message = "じゃ--ん"
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            message = "けーーん"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            message = "ぽん"
                            
                            var newPCJankenNumber = 0
                            //repeat {
                            newPCJankenNumber = Int.random(in: 1...3)
                            //} while newPCJankenNumber == pcJankenNumber
                            
                            pcJankenNumber = newPCJankenNumber
                            
                            print(pcJankenNumber)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            
                            if myJankenNumber == 0 {
                                message = "出さなきゃ まけよ"
                                print("出さなきゃ まけよ")
                                lose += 1
                            } else if myJankenNumber == 1 {
                                if pcJankenNumber == 1 {
                                    message = "あいこ"
                                    print("あいこ")
                                    draw += 1
                                } else if pcJankenNumber == 2 {
                                    message = "かち"
                                    print("かち")
                                    win += 1
                                } else if pcJankenNumber == 3 {
                                    message = "まけ"
                                    print("まけ")
                                    lose += 1
                                }
                            } else if myJankenNumber == 2 {
                                if pcJankenNumber == 1 {
                                    message = "まけ"
                                    print("まけ")
                                    lose += 1
                                } else if pcJankenNumber == 2 {
                                    message = "あいこ"
                                    print("あいこ")
                                    draw += 1
                                } else if pcJankenNumber == 3 {
                                    message = "かち"
                                    print("かち")
                                    win += 1
                                }
                            } else if myJankenNumber == 3 {
                                if pcJankenNumber == 1 {
                                    message = "かち"
                                    print("かち")
                                    win += 1
                                } else if pcJankenNumber == 2 {
                                    message = "まけ"
                                    print("まけ")
                                    lose += 1
                                } else if pcJankenNumber == 3 {
                                    message = "あいこ"
                                    print("あいこ")
                                    draw += 1
                                }
                            }
                            //初期化
                            // ゲーム開始ボタン表示
                            // 自分の手をリセット
                            buttonFlag = true
                            myJankenNumber = 0
                        }
                        //soundPlayer.onseiPlay()
                    } label: {
                        Text("Let's Start")
                            .font(.title)
                            .padding()
                    }
                }
                
                if message != "Let's Start" {
                    Text(message)
                        .font(.title)
                        .padding()
                }
                
                Spacer()
                
                Text("You")
                
                ZStack {
                    HStack {
                        Button {
                            useGu = true
                            useChoki = false
                            usePa = false
                            
                            myJankenNumber = 1
                            //print("myJankenNumber=\(myJankenNumber)")
                            print("useGu = \(useGu)")
                        } label: {
                            Image(.gu)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        .background(useGu ? .red : .clear)
                        
                        Button {
                            useGu = false
                            useChoki = true
                            usePa = false
                            
                            myJankenNumber = 2
                            //print("myJankenNumber=\(myJankenNumber)")
                            print("useChoki = \(useChoki)")
                        } label: {
                            Image(.choki)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        .background(useChoki ? .red : .clear)
                        
                        Button {
                            useGu = false
                            useChoki = false
                            usePa = true
                            
                            myJankenNumber = 3
                            //print("myJankenNumber=\(myJankenNumber)")
                            print("usePa = \(usePa)")
                        } label: {
                            Image(.pa)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        .background(usePa ? .red : .clear)
                    }
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Text("設定")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
