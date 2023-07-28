//
//  ContentView.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import SwiftUI

struct ContentView: View {

	let model: AnimeListViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
			Text("Hello, world!").onAppear {
				model.getCombineEvents()
			}
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(model: AnimeListViewModel())
    }
}
