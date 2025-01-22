import Foundation

enum HomeLoadData {
    struct Request {
    }

    struct Response {
        let arts: [ArtHomeModel]
    }

    struct View {
        let arts: [ItemViewModel]
    }
}

enum HomeLoadNextPage {
    struct Request {
    }

    struct Response {
        let arts: [ArtHomeModel]
    }

    struct View {
        let arts: [ItemViewModel]
    }
}

enum HomeError {
    struct Response {
        let error: ArtServiceError
    }

    struct View {
        let errorTitle: String
        let errorMessage: String
    }
}

struct ItemViewModel {
    let imageUrlString: String
    let title: String
}
