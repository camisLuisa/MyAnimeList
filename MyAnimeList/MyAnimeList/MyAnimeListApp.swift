//
//  MyAnimeListApp.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import SwiftUI

@main
struct MyAnimeListApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView(model: AnimeListViewModel())
        }
    }
}
