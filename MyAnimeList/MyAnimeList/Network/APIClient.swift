//
//  APIClient.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import Combine
import Foundation

protocol ApiProtocol {

	func combineRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, ApiError>
}

final class ApiClient: ApiProtocol {

	var session: URLSession {
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		configuration.timeoutIntervalForRequest = 60
		configuration.timeoutIntervalForResource = 300

		return URLSession(configuration: configuration)
	}

	func combineRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, ApiError> {
		do {
			return session
				.dataTaskPublisher(for: try endpoint.asURLRequest())
				.tryMap { output in
					return try self.manageResponse(data: output.data, response: output.response)
				}
				.mapError {
					$0 as? ApiError ?? ApiError(errorCode: "ERROR-0", message: "Unknown API error \($0.localizedDescription)")
				}
				.eraseToAnyPublisher()
		} catch let error as ApiError {
			return AnyPublisher<T, ApiError>(Fail(error: error))
		} catch {
			return AnyPublisher<T, ApiError>(Fail(error: ApiError(
				errorCode: "ERROR-0",
				message: "Unknown API error \(error.localizedDescription)"
			)))
		}
	}

	private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
			guard let response = response as? HTTPURLResponse else {
				throw ApiError(
					errorCode: "ERROR-0",
					message: "Invalid HTTP response"
				)
			}
			switch response.statusCode {
			case 200...299:
				do {
					return try JSONDecoder().decode(T.self, from: data)
				} catch {
					print("‼️", error)
					throw ApiError(
						errorCode: "404",
						message: "Error decoding data"
					)
				}
			default:
				guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
					throw ApiError(
						statusCode: response.statusCode,
						errorCode: "ERROR-0",
						message: "Unknown backend error"
					)
				}
				if response.statusCode == 403 && decodedError.errorCode == "404" {
					NotificationCenter.default.post(name: .NSMetadataQueryDidFinishGathering, object: self)
				}
				throw ApiError(
					statusCode: response.statusCode,
					errorCode: decodedError.errorCode,
					message: decodedError.message
				)
			}
		}
}
