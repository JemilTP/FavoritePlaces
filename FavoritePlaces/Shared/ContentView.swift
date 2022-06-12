//
//  ContentView.swift
//  Shared
//
//  Created by Jemil Pepena on 22/5/2022.
//

import SwiftUI
import CoreData


/// Structure View for the view that shows the list of places (nav links)
struct ContentView: View {
    ///Fetches the data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    ///if a nav link for a place is clicked
    @State var toDetail: Bool = false
   ///body view
    var body: some View {
        
        NavigationView {
            List {
                ForEach(places) { place in
                    HStack{
                        ///if image link is not empty , also unwraps value
                        if place.imageLink != "" , let c = place.imageLink{
                            AsyncImage(url: URL(string:c), content: { image in
                                
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    
                            }, placeholder: {
                                ProgressView()
                            })
                               
                        }else{ ///if no image link, defualt image icon
                            Image("image")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40, maxHeight: 40)
                        }
                        NavigationLink(destination: Detail(place: place), label: {
                            Text(place.name ?? "NO NAME")
                        } )
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            ///Nav bar items
            .navigationBarTitle("Favorite Places")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }

                ToolbarItem (placement: .navigationBarLeading){
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
       
    }
    
    /// adds a new place
    private func addItem() {
        withAnimation {
            let newPlace = Place(context: viewContext)
            ///deault values
            newPlace.name = "New Place"
            newPlace.imageDetail = ""
            newPlace.imageLink = ""
            newPlace.latitude = 0.0
            newPlace.longtitude = 0.0
            do {
                try viewContext.save() ///saves to core data
            } catch {
               
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// delates places
   
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
               
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


