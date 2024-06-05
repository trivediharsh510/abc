//
//  EditPasswordView.swift
//  PassWordManager
//
//  Created by HARSH TRIVEDI on 05/06/24.
//

import SwiftUI

struct EditPasswordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var password: Password
    @State private var decryptedPassword: String = ""
    private let encryptionKey = "your-encryption-key-here"

    var body: some View {
        Form {
            Section(header: Text("Account Details")) {
                TextField("Account Type", text: Binding(
                    get: { password.accountType ?? "" },
                    set: { password.accountType = $0 }
                ))
                TextField("Username/Email", text: Binding(
                    get: { password.username ?? "" },
                    set: { password.username = $0 }
                ))
                SecureField("Password", text: $decryptedPassword)
            }
            
            Button("Save") {
                updatePassword()
            }
        }
        .navigationTitle("Edit Password")
        .onAppear {
            if let encryptedPassword = password.password {
                decryptedPassword = EncryptionHelper.decrypt(encryptedText: encryptedPassword, key: encryptionKey) ?? ""
            }
        }
    }
    
    private func updatePassword() {
        password.password = EncryptionHelper.encrypt(text: decryptedPassword, key: encryptionKey)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
