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
    
    @State var place: Place
    @State var mode: EditMode = .inactive
    var body: some View {
        VStack{
            VStack{
                                if mode == .inactive{
                    if let c = place.imageLink{
                        AsyncImage(url: URL(string: c))
                    }
                    Text(place.name ?? "")
                    Text(place.imageLink ?? "")
                    Text(place.imageDetail ?? "")
                    Text(String(place.latitude ))
                    Text(String(place.longtitude))
                }else{
                   
                    TextField("Name", text: Binding($place.name)!)
                    TextField("URL", text:Binding($place.imageLink)!)
                    Text("Enter location detials")
                    
                    TextField("Details", text: Binding($place.imageDetail)!)
                    TextField("Longtitude", value: $place.longtitude, format: .number)
                    TextField("Latitude", value: $place.latitude, format: .number)
                         
                    
                    
                }
            }.padding(.leading)
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



