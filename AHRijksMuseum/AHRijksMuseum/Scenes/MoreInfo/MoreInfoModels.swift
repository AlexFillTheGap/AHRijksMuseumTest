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

struct MoreInfoLocalViewModel {
    let screenTitle: String
    let imageUrlString: String
    let title: String
}
