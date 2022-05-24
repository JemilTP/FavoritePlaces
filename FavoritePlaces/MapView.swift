//
//  MapView.swift
//  FavoritePlaces (iOS)
//
//  Created by Jemil Pepena on 25/5/2022.
//

import SwiftUI
import MapKit
struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    @State var place: Place
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
  /*  let p: Place?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    init(p: Place? = nil) {
       self.p = p
        if let x = p{
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.p.latitude, longitude: self.p.longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    } */
    
    
    var body: some View {
        VStack{
            Map(coordinateRegion: $region)
            HStack{
                Text(place.name ?? "")
                Text("Latitude: ")
              
                    TextField("", value: $place.latitude, format: .number)
                
                
            }
            
            HStack{
                Text("Longtitude: ")
                TextField("", value: $place.longtitude, format: .number)
            }
        }.navigationBarTitle(String(place.name ?? ""))
            .padding(.leading)
            .padding(.trailing)
            .onAppear{
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            }
    }
}
/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
*/
