//
//  BookListView.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookViewModel()
    @State private var showingAddCustomBook = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books + viewModel.customBooks) { book in
                    NavigationLink(destination: BookDetailView(viewModel: viewModel, book: book)) {
                        BookRow(book: book, isFavorite: viewModel.favoriteBooks.contains(book.id))
                    }
                }
            }
            .navigationTitle("Books")
            .toolbar {
                Button(action: {
                    showingAddCustomBook = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCustomBook) {
            AddCustomBookView(viewModel: viewModel)
        }
    }
}

struct BookRow: View {
    let book: Book
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.cover)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 75)
            .cornerRadius(4)
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
        }
    }
}
