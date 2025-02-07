//
//  final_ring_sizerApp.swift
//  final_ring_sizer
//
//  Created by MANYA on 29/09/24.
//

import SwiftUI

@main
struct final_ring_sizerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TestTab()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
