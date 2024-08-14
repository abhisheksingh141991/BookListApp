//
//  AddCustomBookView.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import SwiftUI

struct AddCustomBookView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var description = ""
    @State private var coverURL = ""
    @State private var publicationDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Description", text: $description)
                TextField("Cover URL", text: $coverURL)
                DatePicker("Publication Date", selection: $publicationDate, displayedComponents: .date)
            }
            .navigationTitle("Add Custom Book")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newBook = createNewBook()
                viewModel.addCustomBook(newBook)
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(title.isEmpty || author.isEmpty)
            )
        }
    }
    
    private func createNewBook() -> Book {
           let newId = getNextAvailableId()
           return Book(
               id: newId,
               title: title,
               author: author,
               description: description,
               cover: coverURL,
               publicationDate: ISO8601DateFormatter().string(from: publicationDate),
               isFavorite: false,
               isCustom: true
           )
       }
    
    private func getNextAvailableId() -> Int {
        let allBooks = viewModel.books + viewModel.customBooks
        let maxId = allBooks.map { $0.id }.max() ?? 0
        return maxId + 1
    }
}
