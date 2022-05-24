//
//  Detail.swift
//  FavoritePlaces
//
//  Created by Jemil Pepena on 22/5/2022.
//

import SwiftUI
import CoreData

struct Detail: View {
    /*
    @State var name : String
    @State var imageLink : String
    @State var details : String
    @State var latitude : Double
    @State var longtitude : Double
    */
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    @State var place: Place
    @State var mode: EditMode = .inactive
    
  
    
    var body: some View {
        VStack{
            VStack{
                                if mode == .inactive{
                    if let c = place.imageLink{
                        AsyncImage(url: URL(string: c), content:{
                            image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                //.frame(maxWidth: 40, maxHeight: 40)
                        }, placeholder: {
                            ProgressView()
                            
                        })
                    }
                    Text(place.imageDetail ?? "")
                                    NavigationLink(destination: MapView(place: place), label: {
                                        Text("Map of \(place.name ?? "")")
                                    })
                    Text("Latitude: \(String(place.latitude ))")
                    Text("Longtitude: \(String(place.longtitude))").onDisappear{
                        try?  viewContext.save()
                    }
                                   
                }else{
                    HStack{
                        Text("Name: ")
                        TextField("Name", text: Binding($place.name)!)
                    }
                    HStack{
                        /*Button("Clear"){
                            place.imageLink = ""
                        }.foregroundColor(Color.blue)*/
                        
                        Text("Image URL: ")
                        TextField("URL", text:Binding($place.imageLink)!)
                    }
                        Text("Enter location detials")
                    
                        TextField("Details", text: Binding($place.imageDetail)!)
                    HStack{
                        Text("Longtitude: ")
                        TextField("Longtitude", value: $place.longtitude, format: .number)
                    }
                    HStack{
                        Text("Latitude: ")
                        TextField("Latitude", value: $place.latitude, format: .number)
                    }
                    
                    
                }
            }
                .padding(.leading)
                .padding(.trailing)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }.navigationBarTitle(place.name ?? "")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .toolbar{
                ToolbarItem(placement:. navigationBarTrailing){
                    EditButton()
                }
            }
    .environment(\.editMode, $mode) //attach var mode to edit mode of the environment
    }
}
/*
struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail()
    }
}
*/



