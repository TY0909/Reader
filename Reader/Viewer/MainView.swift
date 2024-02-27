//
//  NavigationView.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pdfBooks: [PDFBook]
    @State private var showAddPDF = false
    let layout = [GridItem(), GridItem(), GridItem()]
    @State private var currentPage = 0
    @State private var showOutlineView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(pdfBooks, id: \.id) { pdf in
                        NavigationLink {
                            ReadView(pdfDoc: pdf, currentPage: $currentPage)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button(action: {
                                            showOutlineView.toggle()
                                        }, label: {
                                            Image(systemName: "list.bullet.rectangle.portrait")
                                        })
                                        .padding()
                                    }
                                }
                                .statusBarHidden(true)
                                .sheet(isPresented: $showOutlineView) {
                                    OutlineView(pdf: pdf) { goToPage in
                                        currentPage = goToPage
                                    }
                                }
                                .onDisappear {
                                    pdf.lastReaderPage = currentPage
                                    print("currentpage:\(currentPage), lastpage:\(pdf.lastReaderPage) exit")
                                }
                        } label: {
                            VStack {
                                CoverView(pdf: pdf)
                                    .contextMenu {
                                        Button("Delete", role: .destructive) {
                                            modelContext.delete(pdf)
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                ToolbarItem {
                    Button {
                        showAddPDF.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .fileImporter(isPresented: $showAddPDF, allowedContentTypes: [.pdf]) { result in
                do {
                    let pdfurl = try result.get()
                    addItem(pdfURL: pdfurl)
                } catch {
                    print("Failed to import pdf: \n\(error.localizedDescription)")
                }
            }
        }
    }

    private func addItem(pdfURL: URL) {
        withAnimation {
            _ = pdfURL.startAccessingSecurityScopedResource()
            let newPDF = PDFBook(pdfURL: pdfURL)
            if !pdfBooks.contains(where: { $0.pdfData == newPDF.pdfData}) {
                modelContext.insert(newPDF)
                print("success import")
            } else {
                print("failed to importer file")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(pdfBooks[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: PDFBook.self, inMemory: true)
}
