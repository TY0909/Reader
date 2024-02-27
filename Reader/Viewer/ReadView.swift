//
//  ReadView.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import SwiftUI
import PDFKit

struct ReadView: UIViewRepresentable {
    let pdfDoc: PDFBook
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> PDFView {
        guard let doc = PDFDocument(data: pdfDoc.pdfData) else { fatalError() }
        let pdf = PDFView()
        pdf.document = doc
        if let lastpage = pdf.document?.page(at: pdfDoc.lastReaderPage - 1) {
            pdf.go(to: lastpage)
        }
        pdf.autoScales = true
        pdf.displayMode = .singlePage
        pdf.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(forName: .PDFViewPageChanged, object: pdf, queue: .main) { _ in
            self.currentPage = pdf.currentPage?.pageRef?.pageNumber ?? 0
            self.pdfDoc.lastReaderPage = self.currentPage
            print("currentpage:\(currentPage), lastpage:\(self.pdfDoc.lastReaderPage)")
        }
        // add swip gesture recognizer
        let swipeLeft = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.swipeLeft))
        swipeLeft.direction = .left
        pdf.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.swipeRight))
        swipeRight.direction = .right
        pdf.addGestureRecognizer(swipeRight)
        
        return pdf
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let page = uiView.document?.page(at: currentPage - 1) {
            uiView.go(to: page)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ReadView

        init(_ parent: ReadView) {
            self.parent = parent
        }

        @objc func swipeLeft(gesture: UISwipeGestureRecognizer) {
            if let pdfView = gesture.view as? PDFView {
                pdfView.goToNextPage(nil)
            }
        }

        @objc func swipeRight(gesture: UISwipeGestureRecognizer) {
            if let pdfView = gesture.view as? PDFView {
                pdfView.goToPreviousPage(nil)
            }
        }
    }
}

#Preview {
    ReadView(pdfDoc: testBook, currentPage: .constant(1))
}
