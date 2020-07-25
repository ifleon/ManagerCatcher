//
//  Created by administrador on 02/05/2020.
//  Copyright © 2020 administrador. All rights reserved.
//

import Foundation


public class CoreDependency: CoreDependencyProvider {
    private lazy var cacheMngr = MemoryCacheManager()

    public init() {}
    deinit {}
    
    public func cacheManager() -> MemoryCacheManager {
        return cacheMngr
    }
}
