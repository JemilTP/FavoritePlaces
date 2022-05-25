//
//  MapView.swift
//  FavoritePlaces (iOS)
//
//  Created by Jemil Pepena on 25/5/2022.
//

import SwiftUI
import MapKit

struct Location: Identifiable{
    let id = UUID()
        let name: String
        var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var places: FetchedResults<Place>
    @State var place: Place
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var latitude: Double 
    @State var longtitude: Double
    @State var location: Location = Location(name: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    @State var locations: [Location] = []
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var x: Double = 0.0
    @State var y: Double = 0.0
 

    var body: some View {
        VStack{
            Map(coordinateRegion: $region
                ,annotationItems: locations){
                
                location in
                MapAnnotation(coordinate: location.coordinate){
                    Circle()
                        .fill(.red)
                        
                }
            }
            Button("print"){
                print(region)
                print(latitude)
            }
            HStack{
                
                Text("Latitude: ")
              
                TextField("", value: $latitude, format: .number).onSubmit{
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    locations[0].coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                 
                    
                }
                
                
                
            }
        
            HStack{
                Text("Longtitude: ")
                TextField("", value: $longtitude, format: .number).onSubmit{
                  
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    locations[0].coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                }
            }
        }
        .onReceive(timer){
            time in
          
            if x != region.center.latitude || y != region.center.longitude{
                print("s")
                latitude = region.center.latitude
                longtitude = region.center.longitude
            }
            x = region.center.latitude
            y = region.center.longitude
        }
        .navigationBarTitle(String(place.name ?? ""))
            .padding(.leading)
            .padding(.trailing)
            .onAppear{
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                location.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude)
                locations = [location]
          
            }
            .onDisappear{
                place.longtitude = longtitude
                place.latitude = latitude
                try? viewContext.save()
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
