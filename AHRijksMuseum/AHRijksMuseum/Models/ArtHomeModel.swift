import Foundation

struct ArtHomeModel {
    let identifier: String
    let listTitle: String
    let detailTitle: String
    let listImageUrlString: String
    let detailImageUrlString: String
}

struct ArtHomeData: Decodable {
    let maxNumberArts: Int
    let arts: [ArtHomeModel]

    init(maxNumerArts: Int, arts: [ArtHomeModel]) {
        self.maxNumberArts = maxNumerArts
        self.arts = arts
    }

    enum CodingKeys: String, CodingKey {
        case artObjects
        case count
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        maxNumberArts = try container.decode(Int.self, forKey: .count)

        let artObjects = try container.decode([ArtData].self, forKey: .artObjects)
        arts = artObjects.map({ data in
            ArtHomeModel(
                identifier: data.objectNumber,
                listTitle: data.title,
                detailTitle: data.longTitle,
                listImageUrlString: data.headerImage.url,
                // data webImage url can be null so we just take headerImage
                detailImageUrlString: data.webImage?.url ?? data.headerImage.url
            )
        })
    }
}

private struct ArtData: Decodable {
    let objectNumber: String
    let title: String
    let longTitle: String
    let webImage: ImageData?
    let headerImage: ImageData
}

private struct ImageData: Decodable {
    let url: String
}
