//
//  BookDetailView.swift
//  BookListApp
//
//  Created by Abhishek Kumar Singh on 14/08/24.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookViewModel
    let book: Book
    
    @State private var showingEditCustomBook = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: book.cover)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .cornerRadius(8)
                
                Text(book.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("By \(book.author)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Published on \(formattedDate(book.publicationDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(book.description)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Book Details", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                viewModel.toggleFavorite(for: book)
            }) {
                Image(systemName: viewModel.favoriteBooks.contains(book.id) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            
            if book.isCustom ?? false {
                Menu {
                    Button("Edit") {
                        showingEditCustomBook = true
                    }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteCustomBook(book)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        })
        .sheet(isPresented: $showingEditCustomBook) {
            EditCustomBookView(viewModel: viewModel, book: book)
        }
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
}
