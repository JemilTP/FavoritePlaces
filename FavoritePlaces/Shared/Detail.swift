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


///Struct for detail view
struct Detail: View {
    ///loads data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    
    ///Place object passed from ContentView
    @State var place: Place
    
    /// If edit mode is on
    @State var mode: EditMode = .inactive
    ///region object holding coordinates of place
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    /// sunrise data and time, given todays date as init
    @State var sunrise: Date = Date.now
    /// sunset data and time, given todays data as init
    @State var sunset: Date = Date.now
    
    ///body view
    var body: some View {
        VStack{
            VStack{
                        ///when not in edit mode, show place details
                                if mode == .inactive{
                    if let c = place.imageLink{
                        AsyncImage(url: URL(string: c), content:{ ///place image
                            image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                             
                        }, placeholder: {
                            ProgressView()
                            
                        })
                    }
                    Text(place.imageDetail ?? "") ///place name
                                    HStack{
                                        Map(coordinateRegion: $region).frame(maxWidth: 40, maxHeight: 40) ///mini map
                                            .scaledToFit()
                                        
                                    NavigationLink(destination: MapView(place: place, latitude: place.latitude, longtitude: place.longtitude), label: {
                                        Text("Map of \(place.name ?? "")")
                                    })
                                    }
                                    ///coordiantes
                    Text("Latitude: \(String(place.latitude ))")
                    Text("Longtitude: \(String(place.longtitude))").onDisappear{
                        try?  viewContext.save() ///saves to core data, will happen when leaving this view
                    }
                                    Spacer()
                                    ///sunrise and sunset
                                    HStack{
                                        Text("Sunrise: \(sunrise)")
                                            .padding(.leading)
                                        Spacer()
                                        Text("Sunset: \(sunset)")
                                            .padding(.trailing)
                                    }
                }else{
                    ///if in edit mode show the folowing:
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
                ///set map coordinateds to coordinates saved to core data
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
               /// calculate sunrise and sunset using solar swift package
                let solar = Solar(for: Date.now, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude))
             
                sunrise = solar?.sunrise ?? Date.now
             
                
                sunset = solar?.sunset ?? Date.now
             
            }
    .environment(\.editMode, $mode) ///attach var mode to edit mode of the environment
    }
}



