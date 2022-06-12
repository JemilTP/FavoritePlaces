//
//  Detail.swift
//  FavoritePlaces
//
//  Created by Jemil Pepena on 22/5/2022.
//

import SwiftUI
import CoreData
import MapKit
import Solar



struct Detail: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    @State var place: Place
    @State var mode: EditMode = .inactive
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var sunrise: Date = Date.now
    @State var sunset: Date = Date.now
    //var solar: Solar
    var body: some View {
        VStack{
            VStack{
                                if mode == .inactive{
                    if let c = place.imageLink{
                        AsyncImage(url: URL(string: c), content:{
                            image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                             
                        }, placeholder: {
                            ProgressView()
                            
                        })
                    }
                    Text(place.imageDetail ?? "")
                                    HStack{
                                        Map(coordinateRegion: $region).frame(maxWidth: 40, maxHeight: 40)
                                            .scaledToFit()
                                        
                                    NavigationLink(destination: MapView(place: place, latitude: place.latitude, longtitude: place.longtitude), label: {
                                        Text("Map of \(place.name ?? "")")
                                    })
                                    }
                    Text("Latitude: \(String(place.latitude ))")
                    Text("Longtitude: \(String(place.longtitude))").onDisappear{
                        try?  viewContext.save()
                    }
                                    Spacer()
                                    HStack{
                                        Text("Sunrise: \(sunrise)")
                                            .padding(.leading)
                                        Spacer()
                                        Text("Sunset: \(sunset)")
                                            .padding(.trailing)
                                    }
                }else{
                    HStack{
                        Text("Name: ")
                        TextField("Name", text: Binding($place.name)!)
                    }
                    HStack{
                 
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
            .onAppear{
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
               
                let solar = Solar(for: Date.now, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude))
             
                sunrise = solar?.sunrise ?? Date.now
             
                
                sunset = solar?.sunset ?? Date.now
             
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



