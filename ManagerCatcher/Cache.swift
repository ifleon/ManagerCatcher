//
//
//  Created by administrador on 01/05/2020.
//  Copyright © 2020 administrador. All rights reserved.
//

import Foundation

extension Cache {
    
    enum Key: String {
        case application
        case session
        case user
        
        var scope: CacheScope {
            switch self {
                default: return .session
            }
        }
    }
}

@propertyWrapper
struct Cache<T: Codable> {

    let cacheManager: MemoryCacheManager
    let key: String
    let scope: CacheScope

    init(cacheManager: MemoryCacheManager = CoreDependencyContainer.dependencies.cacheManager(),
         key: String, scope: CacheScope = .session ){
        self.cacheManager = cacheManager
        self.key = key
        self.scope = scope
    }
    
    init(cacheManager: MemoryCacheManager = CoreDependencyContainer.dependencies.cacheManager(),
         _ key: Key){
        self.cacheManager = cacheManager
        self.key = key.rawValue
        self.scope = key.scope
    }
    
    init(key: Key, scope: CacheScope){
        self.cacheManager = CoreDependencyContainer.dependencies.cacheManager()
        self.key = key.rawValue
        self.scope = scope
    }

    var wrappedValue: T? {
        get {
            cacheManager.value(forKey: key, type: T.self)
        }
        set {
           if let newValue = newValue {
                cacheManager.put(newValue, forKey: key, scope: scope.rawValue)
           } else {
               cacheManager.removeValue(forKey: key)
           }
       }
   }

}

