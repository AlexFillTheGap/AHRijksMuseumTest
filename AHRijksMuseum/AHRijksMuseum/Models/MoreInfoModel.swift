import Foundation

struct MoreInfoModel: Sendable {
    let identifier: String
    let screenTitle: String
    let title: String
    let description: String
    let imageUrlString: String
    let imageBackgroundColorString: String?

    init(
        identifier: String,
        screenTitle: String,
        title: String,
        description: String,
        imageUrlString: String,
        imageBackgroundColorString: String?
    ) {
        self.identifier = identifier
        self.screenTitle = screenTitle
        self.title = title
        self.description = description
        self.imageUrlString = imageUrlString
        self.imageBackgroundColorString = imageBackgroundColorString
    }

    init(from artList: ArtHomeModel) {
        self.identifier = artList.identifier
        self.screenTitle = artList.detailTitle
        self.title = artList.detailTitle
        self.description = ""
        self.imageUrlString = artList.detailImageUrlString
        self.imageBackgroundColorString = nil
    }
}

struct MoreInfoData: Decodable {
    let art: MoreInfoModel

    enum CodingKeys: String, CodingKey {
        case artObject
    }

    init(art: MoreInfoModel) {
        self.art = art
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let artObject = try container.decode(MoreInfoArtData.self, forKey: .artObject)
        art = MoreInfoModel(
            identifier: artObject.objectNumber,
            screenTitle: artObject.titles.first ?? artObject.title,
            title: artObject.title,
            description: artObject.description,
            imageUrlString: artObject.webImage.url,
            imageBackgroundColorString: artObject.colors.first?.hex
        )
    }
}

private struct MoreInfoArtData: Decodable {
    let objectNumber: String
    let title: String
    let webImage: ImageData
    let titles: [String]
    let description: String
    let colors: [ColorData]
}

private struct ImageData: Decodable {
    let url: String
}

private struct ColorData: Decodable {
    let hex: String
}
