import Foundation
import UIKit

enum MoreInfoInitialData {
    struct Request {}

    struct Response {
        let artMoreInfo: MoreInfoModel
    }

    struct View {
        let artViewModel: MoreInfoLocalViewModel
    }
}

enum MoreInfoRemoteData {
    struct Request {
    }

    struct Response {
        let artMoreInfo: MoreInfoModel
    }

    struct View {
        let artViewModel: MoreInfoRemoteViewModel
    }
}

struct MoreInfoLocalViewModel {
    let screenTitle: String
    let imageUrlString: String
    let title: String
}

struct MoreInfoRemoteViewModel {
    let title: String?
    let description: String?
    let imageBackgroundColor: UIColor?
}
