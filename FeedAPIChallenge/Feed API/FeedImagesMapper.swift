//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by Pavan Powani on 03/08/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

class FeedImagesMapper {
	struct ImagesRoot: Decodable {
		private var items: [Item]

		var feedImages: [FeedImage] {
			return items.map({ $0.feedImage })
		}
	}

	fileprivate struct Item: Decodable {
		var id: UUID
		var description: String?
		var location: String?
		var url: URL

		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}

		var feedImage: FeedImage {
			return FeedImage(id: id, description: description, location: location, url: url)
		}
	}

	static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == 200, let images = try? JSONDecoder().decode(ImagesRoot.self, from: data) else { return .failure(RemoteFeedLoader.Error.invalidData) }
		return .success(images.feedImages)
	}
}
