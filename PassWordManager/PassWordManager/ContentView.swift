import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Password.accountType, ascending: true)],
        animation: .default)
    private var passwords: FetchedResults<Password>
    
    @State private var showAddPassword = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(passwords) { password in
                    NavigationLink(destination: EditPasswordView(password: password)) {
                        VStack(alignment: .leading) {
                            Text(password.accountType ?? "Unknown")
                                .font(.headline)
                            Text(password.username ?? "No username")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deletePasswords)
            }
            .navigationTitle("Passwords")
            .navigationBarItems(trailing: Button(action: {
                showAddPassword.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddPassword) {
                AddPasswordView().environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deletePasswords(offsets: IndexSet) {
        withAnimation {
            offsets.map { passwords[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

