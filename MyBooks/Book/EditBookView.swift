//
//  EditBookView.swift
//  MyBooks
//
//  Created by Anypli M1 Air on 9/5/2024.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    @State private var recommendedBy = ""
    @State private var showGenre = false
    
    var body: some View {
        HStack {
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView {
                    if newValue == .onShelf {
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .completed {
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        dateStarted = Date.now
                    } else if newValue == .completed && oldValue == .onShelf {
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else {
                        dateCompleted = Date.now
                    }
                }
                firstView = false
            }
            
            Divider()
            
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $recommendedBy)
            } label: {
                Text("Recommended by").foregroundStyle(.secondary)
            }
            
            Divider()
            
            Text("synopsis").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .stroke(
                        Color(
                            uiColor: .tertiarySystemFill
                        ),
                        lineWidth: 2
                    )
                )
            if let genres = book.genres {
                ViewThatFits {
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenresStackView(genres: genres)
                    }
                }
            }
            
            HStack {
                Button("Genre", systemImage: "bookmark.fill") {
                    showGenre.toggle()
                }
                .sheet(isPresented: $showGenre){
                    GenresView(book: book)
                }
                
                NavigationLink {
                    QuoteListView(book: book)
                } label: {
                    let count = book.quotes?.count ?? 0
                    //      Plural localizable
                    Label("\(count) Quotes", systemImage: "quote.opening")
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update") {
                    book.status = status.rawValue
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.synopsis = summary
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    book.recommendedBy = recommendedBy
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = Status(rawValue: book.status)!
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.synopsis
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
            recommendedBy = book.recommendedBy
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: book.status)!
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.synopsis
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    
    return NavigationStack {
        EditBookView(book: books[4])
            .modelContainer(preview.container)
    }
}
