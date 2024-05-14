//
//  QuoteListView.swift
//  MyBooks
//
//  Created by Anypli M1 Air on 10/5/2024.
//

import SwiftUI
import SwiftData

struct QuoteListView: View {
    @Environment(\.modelContext) private var modelContext
    let book: Book
    @State private var text = ""
    @State private var page = ""
    @State private var selectedQuote: Quote?
    private var isEdition: Bool {
        selectedQuote != nil
    }
    
    var body: some View {
        GroupBox {
            HStack {
                LabeledContent("Page") {
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    
                    Spacer()
                }
                
                if isEdition {
                    Button("Cancel") {
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }
                    .buttonStyle(.bordered)
                }
                
                Button(isEdition ? "Update" : "Create") {
                    if isEdition {
                        selectedQuote?.text = text
                        selectedQuote?.page = page.isEmpty ? nil : page
                        page = ""
                        text = ""
                        selectedQuote = nil
                    } else {
                        let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
                        book.quotes?.append(quote)
                        text = ""
                        page = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.isEmpty)
            }
            
            TextEditor(text: $text)
                .border(.secondary)
                .frame(height: 100)
        }
        .padding(.horizontal)
        
        List {
            let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.createdData)) ?? []
            return ForEach(sortedQuotes) { quote in
                VStack(alignment: .leading) {
                    Text(quote.createdData, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(quote.text)
                    
                    HStack {
                        Spacer()
                        
                        if let page = quote.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedQuote = quote
                    text = quote.text
                    page = quote.page ?? ""
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        let quote = sortedQuotes[index]
                        book.quotes?.forEach({ bookQuote in
                            if quote.id == bookQuote.id {
                                modelContext.delete(quote)
                            }
                        })
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks // If set a variable here the preview crashes when you add new item
    preview.addExamples(books)
    
    return NavigationStack{
        QuoteListView(book: books[4])
            .modelContainer(preview.container)
    }
}
