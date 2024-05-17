//
//  ContentView.swift
//  MusicKitFunction
//
//  Created by 本田輝 on 2024/05/17.
//

import MusicKit
import SwiftUI
import MediaPlayer

struct ContentView: View {
    @StateObject var viewModel: MusicKitViewModel
    var musicSubscription: MusicSubscription?
    var body: some View {
        VStack {
            
            if MPMusicPlayerController.systemMusicPlayer.nowPlayingItem == nil, musicSubscription?.canPlayCatalogContent != false {
                Text("Apple Musicで音楽を再生してください")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom,30)
            } else {
                //リアルタイムで聴いてる曲を取ってこれる
                Text(MPMusicPlayerController.systemMusicPlayer.nowPlayingItem!.title!)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.bottom,30)
                    .onAppear(perform: {
                        Task {
                           try await viewModel.getCrrentMusic()
                            try await MusicKitViewModel.getSpecificSongsOnCatalog(ID: viewModel.response.items.last!.id)
                            try await viewModel.getSpecificSongsOnCatalogWithName(title: "ファジーネーブル", artist: "CONTON CANDY")
                        }
                    })
            }
            
        }
        .padding()
    }
}
