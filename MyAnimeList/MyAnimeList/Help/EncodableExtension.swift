//
//  EncodableExtension.swift
//  MyAnimeList
//
//  Created by Camila Luisa Farias on 28/07/2023.
//

import Foundation

extension Encodable {

	var toDictionary: [String: Any]? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
	}
}
