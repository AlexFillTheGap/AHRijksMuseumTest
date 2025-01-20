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

struct ItemViewModel {
    let imageUrlString: String
    let title: String
}
