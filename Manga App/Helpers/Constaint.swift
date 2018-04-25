//
//  Constaint.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/26/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import Foundation
import UIKit

let hostImgLink = "http://cdn.mangaeden.com/mangasimg/"
let apiHost = "https://www.mangaeden.com/api/"


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

func formatDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY / MM / dd"
    return dateFormatter.string(from: date)
}
