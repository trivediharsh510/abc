//
//  AddPasswordView.swift
//  PassWordManager
//
//  Created by HARSH TRIVEDI on 05/06/24.
//

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var accountType = ""
    @State private var username = ""
    @State private var password = ""
    private let encryptionKey = "your-encryption-key-here"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Account Type", text: $accountType)
                    TextField("Username/Email", text: $username)
                    SecureField("Password", text: $password)
                }
                
                Button("Save") {
                    addPassword()
                }
            }
            .navigationTitle("Add Password")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addPassword() {
        withAnimation {
            let newPassword = Password(context: viewContext)
            newPassword.accountType = accountType
            newPassword.username = username
            newPassword.password = EncryptionHelper.encrypt(text: password, key: encryptionKey)
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

