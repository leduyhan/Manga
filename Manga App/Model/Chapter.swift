//
//  Chapter.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/27/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import Foundation

struct ShortChapterDetail {
    var chapterNumber: Int = 0
    var updatedDate: Date = Date()
    var chapterName: String = ""
    var chapterId: String = ""
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        for i in 0..<arr.count {
            switch i {
            case 0:
                guard let chapterNumber = arr[i] as? Int else {return nil}
                self.chapterNumber = chapterNumber
            case 1:
                if let updatedDateTimeInterval = arr[i] as? TimeInterval {
                    let updatedDate = Date(timeIntervalSince1970: updatedDateTimeInterval)
                    self.updatedDate = updatedDate
                }
            case 2:
                if let chapterName = arr[i] as? String {
                    self.chapterName = "Chapter \(chapterName)"
                } else {
                    self.chapterName = "Chapter ..."
                }
            default:
                guard let chapterId = arr[i] as? String else {return nil}
                self.chapterId = chapterId
            }
        }
    }
}

struct ChapterImage {
    var chapterImageId: Int = 0
    var imgLink:String = "http://hclong.xyz/ios/404.jpg"
    var height: Int = 0
    var width: Int = 0
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        for i in 0..<arr.count {
            switch i {
            case 0:
                guard let chapterImageId = arr[i] as? Int else {return nil}
                self.chapterImageId = chapterImageId
            case 1:
                if let imgLink = arr[i] as? String {
                    self.imgLink = "\(hostImgLink)\(imgLink)"
                }
            case 2:
                if i == 2 {
                    guard let width = arr[i] as? Int else { return nil }
                    self.width = width
                }
            default:
                guard let height = arr[i] as? Int else { return nil }
                self.height = height
            }
        }
    }
}
