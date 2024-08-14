//
//  CacheManager.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private init() {}
    
    private let cache = NSCache<NSString, NSData>()
    
    func setData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func getData(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
}
