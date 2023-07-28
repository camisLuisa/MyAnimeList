//
//  AnimeListViewModel.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import UIKit
import Combine

final class AnimeListViewModel: ObservableObject {

	let apiClient: ApiProtocol

	init(apiClient: ApiProtocol = ApiClient()) {
		 self.apiClient = apiClient
	 }

	@Published var animes: [JikanAnimeListResponse] = []
	@Published var eventError: ApiError?
	private var cancellables: Set<AnyCancellable> = []

	func getCombineEvents() {
		let endpoint = EventsEndpoints.getAnimes(page: 1, limit: 1)
		apiClient.combineRequest(endpoint: endpoint, responseModel: [JikanAnimeListResponse].self)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] completion in
				guard let self = self else { return }
				switch completion {
				case .finished:
					break
				case .failure(let error):
					self.eventError = error
				}
			} receiveValue: { [weak self] animes in
				guard let self = self else { return }
				self.animes = animes
				print(animes)
			}
			.store(in: &cancellables)
	}
}
