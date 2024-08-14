//
//  Book.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import Foundation

struct Book: Identifiable, Codable {
    var id: Int
    let title: String
    let author: String
    let description: String
    let cover: String
    let publicationDate: String
    var isFavorite: Bool? = false
    var isCustom: Bool? = false
}
