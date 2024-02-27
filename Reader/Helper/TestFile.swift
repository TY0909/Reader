//
//  TestFile.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/27.
//

import Foundation
import SwiftData

let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try! ModelContainer(for: PDFBook.self, configurations: config)
let url = Bundle.main.url(forResource: "Test", withExtension: ".pdf")!
let testBook = PDFBook(pdfURL: url)

