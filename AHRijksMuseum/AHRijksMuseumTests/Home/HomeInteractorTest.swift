import XCTest
@testable import AHRijksMuseum

final class HomeInteractorTest: XCTestCase {
    var mockArtServicesSuccess: MockArtServicesSuccess!
    var mockArtServicesError: MockArtServicesError!

    override func setUpWithError() throws {
        super.setUp()
        mockArtServicesSuccess = MockArtServicesSuccess()
        mockArtServicesError = MockArtServicesError()
    }

    override func tearDownWithError() throws {
        mockArtServicesSuccess = nil
        mockArtServicesError = nil
        super.tearDown()
    }

    func testLoadSuccessData() async {
        // Given
        let presenter = MockHomePresenter()
        let sut = HomeInteractor(homeResponses: presenter, artService: mockArtServicesSuccess)

        // When
        await sut.doLoadData(request: HomeLoadData.Request())

        // Then
        let arts = await sut.getArts()
        let dataLoaded = await presenter.presentDataLoadedResponse
        XCTAssertGreaterThan(arts.count, 0, "Art list should be greater than 0")
        XCTAssertNotNil(dataLoaded, "Should be not nil")
    }

    func testLoadErrorData() async {
        // Given
        let presenter = MockHomePresenter()
        let sut = HomeInteractor(homeResponses: presenter, artService: mockArtServicesError)

        // When
        await sut.doLoadData(request: HomeLoadData.Request())

        // Then
        let arts = await sut.getArts()
        let dataLoaded = await presenter.presentErrorResponse
        XCTAssertEqual(arts.count, 0, "Art list should be 0")
        XCTAssertNotNil(dataLoaded, "Should be not nil")
    }

    func testNextPageSuccessData() async {
        // Given
        let presenter = MockHomePresenter()
        let sut = HomeInteractor(homeResponses: presenter, artService: mockArtServicesSuccess)

        // When
        await sut.doLoadNextPage(request: HomeLoadNextPage.Request())

        // Then
        let arts = await sut.getArts()
        let dataLoaded = await presenter.presentNextPageResponse
        XCTAssertGreaterThan(arts.count, 0, "Art list should be greater than 0")
        XCTAssertNotNil(dataLoaded, "Should access the presenter mock to show the if is called")
    }

    func testNextPageErrorData() async {
        // Given
        let presenter = MockHomePresenter()
        let sut = HomeInteractor(homeResponses: presenter, artService: mockArtServicesError)

        // When
        await sut.doLoadNextPage(request: HomeLoadNextPage.Request())

        // Then
        let dataLoaded = await presenter.presentErrorResponse
        XCTAssertNotNil(dataLoaded)
    }
}
