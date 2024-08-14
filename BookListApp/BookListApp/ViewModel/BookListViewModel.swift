//
//  BookListViewModel.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import Foundation
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var favoriteBooks: Set<Int> = []
    @Published var customBooks: [Book] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()
        loadCustomBooks()
        fetchBooks()
    }
    
    func fetchBooks() {
        if let cachedData = CacheManager.shared.getData(forKey: "books"),
           let cachedBooks = try? JSONDecoder().decode([Book].self, from: cachedData) {
            self.books = cachedBooks
            updateFavoriteStatus()
        } else {
            APIService.shared.fetchBooks()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching books: \(error)")
                    }
                } receiveValue: { [weak self] books in
                    self?.books = books
                    self?.updateFavoriteStatus()
                    if let encodedData = try? JSONEncoder().encode(books) {
                        CacheManager.shared.setData(encodedData, forKey: "books")
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleFavorite(for book: Book) {
        if favoriteBooks.contains(book.id) {
            favoriteBooks.remove(book.id)
        } else {
            favoriteBooks.insert(book.id)
        }
        saveFavorites()
        updateFavoriteStatus()
    }
    
    func addCustomBook(_ book: Book) {
        customBooks.append(book)
        saveCustomBooks()
    }
    
    func updateCustomBook(_ book: Book) {
        if let index = customBooks.firstIndex(where: { $0.id == book.id }) {
            customBooks[index] = book
            saveCustomBooks()
        }
    }
    
    func deleteCustomBook(_ book: Book) {
        customBooks.removeAll { $0.id == book.id }
        saveCustomBooks()
    }
    
    private func updateFavoriteStatus() {
        books = books.map { book in
            var updatedBook = book
            updatedBook.isFavorite = favoriteBooks.contains(book.id)
            return updatedBook
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteBooks"),
           let favorites = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            favoriteBooks = favorites
        }
    }
    
    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favoriteBooks) {
            UserDefaults.standard.set(encodedData, forKey: "favoriteBooks")
        }
    }
    
    private func loadCustomBooks() {
        if let data = UserDefaults.standard.data(forKey: "customBooks"),
           let custom = try? JSONDecoder().decode([Book].self, from: data) {
            customBooks = custom
        }
    }
    
    private func saveCustomBooks() {
        if let encodedData = try? JSONEncoder().encode(customBooks) {
            UserDefaults.standard.set(encodedData, forKey: "customBooks")
        }
    }
}
