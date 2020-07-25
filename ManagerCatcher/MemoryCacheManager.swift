//
//  Created by administrador on 01/05/2020.
//  Copyright © 2020 administrador. All rights reserved.
//

import Foundation
import UIKit


public enum CacheScope: String {
    case application = "APPLICATION"
    case user = "USER"
    case session = "SESSION"
}

public class MemoryCacheManager {
    
    //key-cache entry map
    private var cache = NSCache<NSString, CacheEntry>()
    
    // key-scope map
    private var keyScope = [String: Set<String>]()
    
    // remove expired Objects Timer
    private var timer: RepeatingBackgroundTimer?
    
    // frequency with which expired objects are deleted in seconds
    private let frequencyForRemoveExpiredObject = 15.0
    
    public var isEmpty: Bool {
        return keyScope.isEmpty
    }
    
    init() {
        self.timer = RepeatingBackgroundTimer(seconds: frequencyForRemoveExpiredObject) {
            self.removeExpiredObjects()
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(clearForMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification
            , object: nil)
        
        cache.evictsObjectsWithDiscardedContent = false
    }

    
    @objc func appMovedToBackground(){
        self.timer?.suspend()
    }
    
    @objc func appMovedToForeground() {
        self.timer?.resume()
    }
    
    deinit {
        self.timer = nil
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    /// Get a String value of the specified type from cache
    ///
    /// - Parameter forKey: The associated key to lookup for.
    /// - Returns: The value if exists and is not expired. Nil otherwise.
    public func string(forKey key: String) -> String? {
        return value(forKey: key, type: String.self)
    }
    
    /// Get a value of the specified type from cache
    ///
    /// - Parameters:
    ///   - forKey: The associated key to lookup for.
    ///   - type: value type to lookup for.
    /// - Returns: The value if exists and is not expired. Nil otherwise.
    public func value<T>(forKey key: String, type: T.Type) -> T? {
        guard let entry = cache.object(forKey: NSString(string: key)) else {
            return nil
        }
        
        guard !entry.hasExpired else {
            removeValue(forKey: key)
            return nil
        }
        if let value = entry.value as? T {
            return value
        }
        return nil
    }

    /// Save a value into cache with time to expire in seconds into scope
    ///
    /// - Parameters:
    ///   - value: The value to save.
    ///   - key: The associated key to save data for.
    ///   - secondsToExpire: num of seconds to expire from now, -1 to never expire.
    ///   - scope: scope if nil, then stores at Aplication scope
    public func put(_ value: Any,
                    forKey key: String,
                    secondsToExpire seconds: Double = -1,
                    scope: String = CacheScope.application.rawValue) {
        let entry = CacheEntry(value: value, secondsToExpire: seconds)
        cache.setObject(entry, forKey: NSString(string: key))
        if let index = key.firstIndex(of: ":") {
            let addScopeKey = key.prefix(upTo: index)
            addToKeyScope(forKey: key, scope: String(addScopeKey))
        }
        addToKeyScope(forKey: key, scope: scope)
    }

    /// Adds a key to a scope
    ///
    /// - Parameters:
    ///   - key: the key
    ///   - scope: the scope where to assign the key
    func addToKeyScope(forKey key: String, scope: String) {
        if keyScope[key] == nil {
            keyScope[key] = Set()
        }
        var scopeToStore = scope
        if scope.hasPrefix(CacheScope.application.rawValue+".") {
            let index = scope.index(scope.startIndex, offsetBy: CacheScope.application.rawValue.count+1)
            scopeToStore = String(scope[index...]);
        }
        keyScope[key]?.insert(scopeToStore)
    }
    
    /// Remove data associated in cache with a specified identifier 'key'.
    ///
    /// - Parameter forKey: The associated key to remove data for.
    public func removeValue(forKey key: String) {
        cache.removeObject(forKey: NSString(string: key))
        keyScope.removeValue(forKey: key)
    }
    
    /// Clears all objects saved for a specified scope.
    ///
    /// - Parameter scope: Scope to clear.
    public func clear(scope: String) {
        if scope == CacheScope.application.rawValue {
            clear()
        } else {
            //if scope starts with APP then remove the prefix
            var scopeToClear = scope
            if scopeToClear.hasPrefix(CacheScope.application.rawValue+".") {
                let index = scopeToClear.index(scopeToClear.startIndex, offsetBy: CacheScope.application.rawValue.count+1)
                scopeToClear = String(scopeToClear[index...]);
            }
            let filtered = keyScope.filter {
                var found = false
                for scopeValue in $0.value {
                    found = (scopeValue == scopeToClear || scopeValue.hasPrefix(scopeToClear+"."))
                    if (found) {
                        break
                    }
                }
                return found
            }
            for key in filtered.keys {
                removeValue(forKey: key)
            }
        }
    }
    
    @objc private func clearForMemoryWarning() {
        print("All item will be deleted from cache due to memory warning!!")
        clear()
    }
    
    /// Clears all objects saved in the cache
    public func clear() {
        cache.removeAllObjects()
        keyScope.removeAll()
    }
    
    //Private Methods
    
    private func removeExpiredObjects() {
        for key in keyScope.keys {
            removeObjectIfExpired(forKey: key)
        }
    }
    
    private func removeObjectIfExpired(forKey key: String) {
        if let entry = cache.object(forKey: NSString(string: key)), entry.hasExpired {
            removeValue(forKey: key)
            print("Removed Expired Object with key: \(key)")
        }
    }
    
}

