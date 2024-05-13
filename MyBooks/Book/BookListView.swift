//
//  ContentView.swift
//  MyBooks
//
//  Created by Anypli M1 Air on 9/5/2024.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    
    @State private var createNewBook = false
    @State private var sortOrder = SortOrder.status
    @State private var filter = ""
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                }
            }
            .buttonStyle(.bordered)
            
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: "Filter on title or author")
                .navigationTitle("My Books")
                .toolbar {
                    Button {
                        createNewBook = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium])
                }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres
    
    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
}

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, author
    
    var id: Self {
        self
    }
}
