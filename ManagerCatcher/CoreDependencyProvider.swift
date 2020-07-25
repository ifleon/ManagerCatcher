//
//  Created by administrador on 01/05/2020.
//  Copyright © 2020 administrador. All rights reserved.
//

import Foundation

public protocol CoreDependencyProvider {
    func cacheManager() -> MemoryCacheManager
}


