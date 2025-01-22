import XCTest
@testable import AHRijksMuseum

final class MoreInfoInteractorTest: XCTestCase {
    var mockArtServicesSuccess: MockArtServicesSuccess!
    var mockArtServicesError: MockArtServicesError!
    private let dataStoreArt = MoreInfoModel(
           identifier: "1",
           screenTitle: "This is the screen title",
           title: "This is the art title",
           description: "",
           imageUrlString: "url",
           imageBackgroundColorString: nil
       )

    override func setUpWithError() throws {
        super.setUp()
        mockArtServicesSuccess = MockArtServicesSuccess()
        mockArtServicesError = MockArtServicesError()
    }

    override func tearDownWithError() throws {
        mockArtServicesSuccess = nil
        mockArtServicesError = nil
    }

    func testDoLoadInitialData() async {
        // Given
        let presenter = MockMoreInfoPresenter()
        let sut = MoreInfoInteractor(moreInfoResponses: presenter, artService: mockArtServicesSuccess)
        await sut.setArt(art: dataStoreArt)

        // When
        let request = MoreInfoInitialData.Request()
        await sut.doLoadInitialData(request: request)

        // Then

        let dataLoaded = await presenter.presentDataLoadedResponse
        XCTAssertNotNil(dataLoaded)
        XCTAssertEqual(dataLoaded?.artMoreInfo.screenTitle, dataStoreArt.screenTitle)
    }

    func testDoLoadRemoteData() async {
        // Given
        let presenter = MockMoreInfoPresenter()
        let sut = MoreInfoInteractor(moreInfoResponses: presenter, artService: mockArtServicesSuccess)
        await sut.setArt(art: dataStoreArt)
        await sut.doLoadInitialData(request: MoreInfoInitialData.Request())

        // When
        let request = MoreInfoRemoteData.Request()
        await sut.doLoadRemoteData(request: request)

        // Then
        let dataLoaded = await presenter.presentRemoteDataLoadedResponse
        XCTAssertNotNil(dataLoaded)
        XCTAssertEqual(dataLoaded?.artMoreInfo.description.isEmpty, false)
        XCTAssertNotNil(dataLoaded?.artMoreInfo.imageBackgroundColorString)
    }

    func testRemoteDataError() async {
        // Given
        let presenter = MockMoreInfoPresenter()
        let sut = MoreInfoInteractor(moreInfoResponses: presenter, artService: mockArtServicesError)
        await sut.setArt(art: dataStoreArt)

        // When
        let request = MoreInfoRemoteData.Request()
        await sut.doLoadRemoteData(request: request)

        // Then
        let dataLoaded = await presenter.presentErrorResponse
        XCTAssertNotNil(dataLoaded)
    }

}
