//
//  MusicKitFunctionApp.swift
//  MusicKitFunction
//
//  Created by 本田輝 on 2024/05/17.
//

import SwiftUI
import MusicKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //諸々realm云々の初期設定が書いてあるであろうところ
        Task {
            
//            await MusicAuthorization.request()　の下
            
            //プレイリストを一回だけ作って以後作られないようにするための分岐
            //関数でまとめたかったらまとめちゃって＾
            let requestPlaylists = MusicLibraryRequest<Playlist>()
            let responsePlaylists = try await requestPlaylists.response()
            let playlists = responsePlaylists.items
            print("🐶",requestPlaylists, responsePlaylists.items)
            if !playlists.contains(where: { $0.name == "created from Music app Playlist" }) {
                try await MusicKitViewModel.createMusicPlaylist()
            }
            
            
        }

        return true
    }
}

@main
struct MusicKitFunctionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(viewModel: .init())
            }
        }
    }
}
