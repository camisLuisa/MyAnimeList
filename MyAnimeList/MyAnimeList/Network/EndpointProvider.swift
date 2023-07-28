//
//  jikanAPIManager.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import Foundation

enum RequestMethod: String {

	case delete = "DELETE"
	case get = "GET"
	case patch = "PATCH"
	case post = "POST"
	case put = "PUT"
}

protocol EndpointProvider {

	var scheme: String { get }
	var baseURL: String { get }
	var path: String { get }
	var queryItems: [URLQueryItem]? { get }
	var method: RequestMethod { get }
}

extension EndpointProvider {

	var scheme: String {
		return "https"
	}

	var baseURL: String {
		return "api.jikan.moe"
	}

	func asURLRequest() throws -> URLRequest {

		var urlComponents = URLComponents()
		urlComponents.scheme = scheme
		urlComponents.host =  baseURL
		urlComponents.path = path

		if let queryItems = queryItems {
			urlComponents.queryItems = queryItems
		}

		guard let url = urlComponents.url else {
			throw ApiError(errorCode: "ERROR-0", message: "URL error")
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.rawValue
//		urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//		urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")

		return urlRequest
	}
}
