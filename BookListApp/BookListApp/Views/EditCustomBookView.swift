//
//  EditCustomBookView.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import SwiftUI

struct EditCustomBookView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let book: Book
    
    @State private var title: String
    @State private var author: String
    @State private var description: String
    @State private var coverURL: String
    @State private var publicationDate: Date
    
    init(viewModel: BookViewModel, book: Book) {
        self.viewModel = viewModel
        self.book = book
        
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author)
        _description = State(initialValue: book.description)
        _coverURL = State(initialValue: book.cover)
        
        let dateFormatter = ISO8601DateFormatter()
        _publicationDate = State(initialValue: dateFormatter.date(from: book.publicationDate) ?? Date())
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Description", text: $description)
                TextField("Cover URL", text: $coverURL)
                DatePicker("Publication Date", selection: $publicationDate, displayedComponents: .date)
            }
            .navigationTitle("Edit Custom Book")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let updatedBook = Book(id: book.id,
                                       title: title,
                                       author: author,
                                       description: description,
                                       cover: coverURL,
                                       publicationDate: ISO8601DateFormatter().string(from: publicationDate),
                                       isFavorite: book.isFavorite,
                                       isCustom: true)
                viewModel.updateCustomBook(updatedBook)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
