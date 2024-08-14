//
//  APIService.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
        private init() {}
        
        private let baseURL = "https://my-json-server.typicode.com/cutamar/mock"
        
        func fetchBooks() -> AnyPublisher<[Book], Error> {
            let url = URL(string: "\(baseURL)/books")!
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: [Book].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        func fetchBookDetails(id: Int) -> AnyPublisher<Book, Error> {
            let url = URL(string: "\(baseURL)/books/\(id)")!
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Book.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    }
