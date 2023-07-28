//
//  EventsEndpoints.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import Foundation

enum EventsEndpoints: EndpointProvider {

	case getAnimes(page: Int, limit: Int)

	var path: String {
		switch self {
		case .getAnimes:
			return "/v4/anime"
		}
	}

	var method: RequestMethod {
		switch self {
		case .getAnimes:
			return .get
		}
	}

	var queryItems: [URLQueryItem]? {

		switch self {
		case .getAnimes(let page, let limit):
			return [
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "limit", value: "\(limit)")
			]
		}
	}

}
