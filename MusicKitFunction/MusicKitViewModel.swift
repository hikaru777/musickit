//
//  MusicKitViewModel.swift
//  MusicKitFunction
//
//  Created by 本田輝 on 2024/05/17.
//

import Foundation
import MusicKit

@MainActor
class MusicKitViewModel: NSObject, ObservableObject {
    
    @Published var musicRequest = MusicRecentlyPlayedRequest<Song>()
    @Published var response: MusicRecentlyPlayedResponse<Song>!
    //最近聴いた曲を最新から順に取得する
    func getCrrentMusic() async throws {
        //limitで取得個数制限
        musicRequest.limit = 30
        response = try await musicRequest.response()
        print("最近聴いた曲",response!.items.debugDescription)
        
    }
    
    
    //apple Music上のデータからidを使って曲の情報を取得する
    func getSpecificSongsOnCatalog(ID: MusicItemID) async throws ->  MusicItemCollection<Song>.Element {
        //試しに上の関数で取ってきた30個目の曲の情報を持ってくる
        //idは曲一つ一つに必ず振られてるからidだけ抑えとけばこれで検索できる
        let Songrequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: ID)
        let Songresponse = try await Songrequest.response()
        let song = Songresponse.items.first
        print("id検索結果",song)
        return song!
    }
    
    
    //idがわかんなくて曲名で検索したい時はこっち
    func getSpecificSongsOnCatalogWithName(title: String, artist: String) async throws -> Task<MusicItemID, Never> {
        //別に返り値は自由でいいただID押さえてる方がもっと詳しい情報取ってこれるし処理楽だから作ったけっっこう力技関数
        //これ使うならID取ってきた後に上の関数との併用おすすめ返り値の設定うまくいかないのよ
            Task {
                var musicID = MusicItemID("")
                do {
                    let Request = MusicCatalogSearchRequest(term: title, types: [Artist.self, Song.self])
                    let Response = try await Request.response()
                    for num in Response.songs {
                        if num.artistName == artist {
                            print("名前使った検索結果",num)
                            musicID = num.id
                        }
                    }
                } catch (let error) {
                    print("アップルミュージックのワード検索",error.localizedDescription)
                }
                return musicID
            }
        
    }
    
    func getMusicDataInUserHeavyRotation() async throws /*-> musicData*/  {
        
        let libURL = URL(string: "https://api.music.apple.com/v1/me/history/heavy-rotation?limit=1")!
        
        let request = MusicDataRequest(urlRequest: URLRequest(url: libURL))
        
        let dataResponse = try await request.response()
        print("😺",String(data: dataResponse.data, encoding: .utf8)!,dataResponse.urlResponse.statusCode)
//        let result = try JSONDecoder().decode(musicData.self, from: dataResponse.data)
//        
//        return result
    }
    
    
    
}
