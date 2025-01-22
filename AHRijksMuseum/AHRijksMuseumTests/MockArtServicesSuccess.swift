@testable import AHRijksMuseum

final class MockArtServicesSuccess: ArtServicesProtocol {

    func fetchArts(page: Int) async throws -> [ArtHomeModel] {
        return [ArtHomeModel(
            identifier: "en-BK-NM-1010",
            listTitle: "Dolls’ house of Petronella Oortman",
            detailTitle: "Dolls’ house of Petronella Oortman, anonymous, c. 1686 - c. 1710",
            listImageUrlString: "https://lh3.ggpht.com/" +
            "QARSFMHdk59lhi0GnyZzxvqkt3rMLpYrBI8dXqEVjnbLgcb4PudxSzYaLxju5Juo4CzwwSC2wlq2ZDUMXw54tIhgmF0=s0",
            detailImageUrlString: "https://lh3.ggpht.com/" +
            "OIaBDlLOhgpAQHGdfYfIh0ygXRqgBNR-tW7se4OTwOtD6dsr6xLAmp8u_pfsqJ-0EqB_wbCF_0mvCl979lWxfFIyFQQ=s0"
        )]
    }

    func fetchArtDetail(artId: String) async throws -> MoreInfoModel {
        return MoreInfoModel(
            identifier: "en-BK-NM-1010",
            screenTitle: "Dolls’ house of Petronella Oortman",
            title: "Dolls’ house of Petronella Oortman, anonymous, c. 1686 - c. 1710",
            description: "Poppenhuis in een kast versierd met marqueterie van schildpad en tin op eikenhouten",
            imageUrlString: "https://lh3.ggpht.com/" +
            "OIaBDlLOhgpAQHGdfYfIh0ygXRqgBNR-tW7se4OTwOtD6dsr6xLAmp8u_pfsqJ-0EqB_wbCF_0mvCl979lWxfFIyFQQ=s0",
            imageBackgroundColorString: "#D9D5C6"
        )
    }
}
