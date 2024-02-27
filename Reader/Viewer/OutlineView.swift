//
//  OutlineView.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import SwiftUI
import SwiftData
import PDFKit

struct PDFOutlineInfo {
    let outline: PDFOutline
    let level: Int
    let indexPage: Int
}

struct OutlineView: View {
    @Environment(\.dismiss) var dismiss
    var pdf: PDFBook
    @State var outlineInfoArray = [PDFOutlineInfo]()
    var onSave: (Int) -> Void
    @State private var goToPage = 1

    init(pdf: PDFBook, onSave: @escaping (Int) -> Void) {
        self.pdf = pdf
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<outlineInfoArray.count, id: \.self) { index in
                    HStack {
                        ForEach(0..<outlineInfoArray[index].level, id: \.self) { lv in
                            Text("  ")
                        }
                        Text(outlineInfoArray[index].outline.label ?? "")
                        Spacer()
                        
                        Text(String(outlineInfoArray[index].indexPage))
                    }
                    .onTapGesture {
                        goToPage = outlineInfoArray[index].indexPage
                        onSave(goToPage)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Outlines")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await getOutline()
            }
        }
    }
    
    func getOutline() async {
        guard let pdf = PDFDocument(data: pdf.pdfData) else { return }
        guard let rootOutline = pdf.outlineRoot else { return }

        for index in 0..<rootOutline.numberOfChildren {
            if let child = rootOutline.child(at: index) {
                getOutlinesRecursively(child, level: 0)
            } else {
                print("faild to add \(index)")
            }
        }
    }
    
    func getOutlinesRecursively(_ outline: PDFOutline, level: Int) {
        guard let destination = outline.destination else { return }
        guard let page = destination.page else { return }
        guard let pageRef = page.pageRef else { return }

        
        let outlineInfo = PDFOutlineInfo(outline: outline, level: level, indexPage: pageRef.pageNumber)
        outlineInfoArray.append(outlineInfo)

        // Recursively process children
        for childIndex in 0..<outline.numberOfChildren {
            if let childOutline = outline.child(at: childIndex) {
                getOutlinesRecursively(childOutline, level: level + 1)
            } else {
                print("Failed to add child at index \(childIndex) for parent outline: \(outline.label ?? "")")
            }
        }
    }
}

#Preview {
    OutlineView(pdf: testBook, onSave: { _ in})
}
