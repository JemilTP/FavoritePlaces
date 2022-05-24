//
//  ContentView.swift
//  Shared
//
//  Created by Jemil Pepena on 22/5/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    @State var toDetail: Bool = false
   // @State var viewPlace =  Place(context: viewContext)
    var body: some View {
        
        NavigationView {
            List {
                ForEach(places) { place in
        
                    NavigationLink(destination: Detail(place: place), label: {
                        Text(place.name ?? "NO NAME")
                    } )
                    
                    
                }
                .onDelete(perform: deleteItems)
            }
            .onAppear{
                print("_______________________")
                print()
                print(type(of: places.first!))
                print(places.first!)
            }
            .navigationBarTitle("Favorite Places")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem (placement: .navigationBarLeading){
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
       
    }

    private func addItem() {
        withAnimation {
            let newPlace = Place(context: viewContext)
           // newItem.timestamp = Date()
            newPlace.name = "New Place"
            newPlace.imageDetail = ""
            newPlace.imageLink = ""
            newPlace.latitude = 0.0
            newPlace.longtitude = 0.0
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
