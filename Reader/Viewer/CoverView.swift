//
//  ThumbnailView.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import SwiftUI
import PDFKit

struct CoverView: View {
    let pdf: PDFBook
        
    var body: some View {
        generateThumbnail()
            .padding()
    }

    func generateThumbnail() -> Image{
        if let pdfDocument = PDFDocument(data: pdf.pdfData) {
            // 获取第一页的PDF页面
            if let pdfPage = pdfDocument.page(at: 0) {
                // 生成略缩图
                let thumbnailSize = CGSize(width: 150, height: 150)
                let thumbnailImage = pdfPage.thumbnail(of: thumbnailSize, for: .artBox)
                let cover = Image(uiImage: thumbnailImage)
                return cover
            }
        }
        return Image(systemName: "questionmark")
    }
}

#Preview {
    CoverView(pdf: testBook)
}
