import XCTest
@testable import AHRijksMuseum

final class MoreInfoPresenterTest: XCTestCase {
    var moreInfoViewMock: MockMoreInfoView!
    var loadedDetail: MoreInfoModel!
    var remoteDetail: MoreInfoModel!

    override func setUpWithError() throws {
        moreInfoViewMock = MockMoreInfoView()
        loadedDetail = MoreInfoModel(
            identifier: "1",
            screenTitle: "This is the screen title",
            title: "This is the art title",
            description: "",
            imageUrlString: "url",
            imageBackgroundColorString: nil
        )

        remoteDetail = MoreInfoModel(
            identifier: "1",
            screenTitle: "This is the screen title",
            title: "This is the art title",
            description: "This is the description of the art",
            imageUrlString: "url",
            imageBackgroundColorString: "#FFFFFF"
        )
    }

    override func tearDownWithError() throws {
        moreInfoViewMock = nil
        loadedDetail = nil
        remoteDetail = nil
    }

    func testPresentLoadedData() async {
        // Given
        let sut = MoreInfoPresenter(moreInfoView: moreInfoViewMock)

        // When
        await sut.presentLoadedData(response: MoreInfoInitialData.Response(artMoreInfo: loadedDetail))

        // Then
        let displayed = await moreInfoViewMock.displayLoadedDataView
        let artViewModel = await moreInfoViewMock.displayLoadedDataView?.artViewModel
        XCTAssertNotNil(displayed)
        XCTAssertEqual(artViewModel?.title.isEmpty, false)
        XCTAssertEqual(artViewModel?.imageUrlString.isEmpty, false)
    }

    func testPresentRemoteData() async {
        // Given
        let sut = MoreInfoPresenter(moreInfoView: moreInfoViewMock)

        // When
        await sut.presentRemoteData(response: MoreInfoRemoteData.Response(artMoreInfo: remoteDetail))

        // Then
        let displayed = await moreInfoViewMock.displayRemoteDataView
        let artViewModel = await moreInfoViewMock.displayRemoteDataView?.artViewModel
        XCTAssertNotNil(displayed)
        XCTAssertEqual(artViewModel?.description?.isEmpty, false)
        XCTAssertNotNil(artViewModel?.imageBackgroundColor)
    }

    func testPresentError() async {
        // Given
        let sut = MoreInfoPresenter(moreInfoView: moreInfoViewMock)

        // When
        await sut.presentError(response: MoreInfoError.Response(error: NetworkError.server))

        // Then
        let displayed = await moreInfoViewMock.displayError
        XCTAssertNotNil(displayed)
        XCTAssertEqual(displayed?.errorMessage, NetworkError.server.message)
    }
}
