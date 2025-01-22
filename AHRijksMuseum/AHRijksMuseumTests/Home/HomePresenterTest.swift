import XCTest
@testable import AHRijksMuseum

final class HomePresenterTest: XCTestCase {
    var homeViewMock: MockHomeView!

    private let artsMock = [
        ArtHomeModel(
            identifier: "1",
            listTitle: "This is the list first art",
            detailTitle: "This is the detail first art",
            listImageUrlString: "url",
            detailImageUrlString: "url"
        )
    ]

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        homeViewMock = nil
    }

    func testPresentLoadData() async {
        // Given
        homeViewMock = await MockHomeView()
        let sut = HomePresenter(homeView: homeViewMock)

        // When
        let response = HomeLoadData.Response(arts: artsMock)
        await sut.presentDataLoaded(response: response)

        // Then
        let displayed = await homeViewMock.displayNewDataView
        let arts = await homeViewMock.displayNewDataView?.arts
        XCTAssertNotNil(displayed)
        XCTAssertEqual(arts?.first?.title, artsMock.first?.listTitle)
    }

    func testPresentNextPageData() async {
        // Given
        homeViewMock = await MockHomeView()
        let sut = HomePresenter(homeView: homeViewMock)

        // When
        let response = HomeLoadNextPage.Response(arts: artsMock)
        await sut.presentNextPage(response: response)

        // Then
        let displayed = await homeViewMock.displayNextPageView
        let arts = await homeViewMock.displayNextPageView?.arts
        XCTAssertNotNil(displayed)
        XCTAssertEqual(arts?.first?.title, artsMock.first?.listTitle)
    }

    func testPresentError() async {
        // Given
        homeViewMock = await MockHomeView()
        let error = NetworkError.noData
        let sut = HomePresenter(homeView: homeViewMock)

        // When
        let response = HomeError.Response(error: error)
        await sut.presentError(response: response)

        // Then
        let displayed = await homeViewMock.displayErrorView
        XCTAssertNotNil(displayed)
    }
}
