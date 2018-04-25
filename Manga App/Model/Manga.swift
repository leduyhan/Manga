//
//  Mangaz.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/25/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import Foundation

typealias JSONData = [String:Any]

struct Manga {
    var title: String
    var alias: String
    var category:[String] = [String]()
    var hits:Int = 0
    var id:String
    var imgLink:String = "http://hclong.xyz/ios/404.jpg"
    var lastedDate:Date = Date()
    var status:Int = 1
    
    init?(data: JSONData) {
        guard let title = data["t"] as? String else { return nil }
        guard let alias = data["a"] as? String else { return nil }
        guard let id = data["i"] as? String else { return nil }
        
        self.title = title
        self.alias = alias
        self.id = id
        
        if let category = data["c"] as? [String] {
            self.category = category
        }
        
        if let hits = data["h"] as? Int {
            self.hits = hits
        }
        
        if let imgLink = data["im"] as? String, imgLink != "" {
            self.imgLink = "\(hostImgLink)\(imgLink)"
        }
        
        if let lastedDateTimeInterval = data["ld"] as? TimeInterval {
            self.lastedDate = Date(timeIntervalSince1970: lastedDateTimeInterval)
        }
        
        if let status = data["s"] as? Int {
            self.status = status
        }
    }
}
