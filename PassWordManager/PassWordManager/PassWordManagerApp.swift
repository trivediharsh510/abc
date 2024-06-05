//
//  PassWordManagerApp.swift
//  PassWordManager
//
//  Created by HARSH TRIVEDI on 05/06/24.
//

import SwiftUI

@main
struct PassWordManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
