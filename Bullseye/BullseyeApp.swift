//
//  BullseyeApp.swift
//  Bullseye
//
//  Created by Rithwik Seth on 8/25/24.
//

import SwiftUI
import RealmSwift

@main
struct BullseyeApp: SwiftUI.App {
    init() {
            let appId = "application-0-lhowrbx"
            Realm.Configuration.defaultConfiguration = Realm.Configuration(
                schemaVersion: 1,
                deleteRealmIfMigrationNeeded: true
            )
            _ = App(id: appId)
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
