//
//  ReaderApp.swift
//  Reader
//
//  Created by M Sapphire on 2024/2/26.
//

import SwiftUI
import SwiftData

@main
struct ReaderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PDFBook.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
