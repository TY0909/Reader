//
//  Item.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import Foundation
import SwiftData

@Model
final class PDFBook {
    var pdfId = UUID()
    var pdfData: Data
    var lastReaderPage: Int
    
    init(pdfURL: URL) {
        do {
            self.pdfData = try Data(contentsOf: pdfURL)
        } catch {
            fatalError("Failed to read data from the given url:\n\(error.localizedDescription)")
        }
        self.lastReaderPage = 1
    }
}
