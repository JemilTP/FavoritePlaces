//
//  MapView.swift
//  FavoritePlaces (iOS)
//
//  Created by Jemil Pepena on 25/5/2022.
//

import SwiftUI
import MapKit
import CoreLocation



/// GeoCode, gets coordianteds from name
/// - Parameters:
///   - address: name of place
func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
   CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
   
}

///reverse geocoder, gets name from corrdiantes
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

///struct holding mapview
struct MapView: View {

    ///place structure given from Detail View
    @State var place: Place
    ///variable holding map coordiantes
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    ///variable to hold latitiude of place
    @State var latitude: Double
    ///Variable to hold longitiude of place
    @State var longtitude: Double
    
    ///timer that updates coordianteds on user dragging the map
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    ///x and y coordiantes used to help update map coordinateds
    @State var x: Double = 0.0
    @State var y: Double = 0.0
    
    ///if in edit mode
    @State var isEdit: Bool = false
    ///sets mode
    @State var mode: EditMode = .inactive
    ///user input place for geocoding
    @State var placeName: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    ///custom back button
    var btnBack : some View { Button(action: {
        place.latitude = region.center.latitude
        place.longtitude = region.center.longitude
           self.presentationMode.wrappedValue.dismiss()
           }) {
               HStack {
               Image("ic_back") // set image here
                   .aspectRatio(contentMode: .fit)
                   .foregroundColor(.white)
                   Text("Go back")
               }
           }
       }
    
    ///body holding map view
    var body: some View {
        VStack{
            ///if in edit mode
            if mode == .active{
                TextField("Place", text: $placeName).onSubmit{ ///name of place for geocoding
                    ///
                    if placeName != ""{
                        
                    getCoordinateFrom(address: placeName) { coordinate, error in ///gets coordinates from placeName
                        guard let coordinate = coordinate, error == nil else { return }
                        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

          
                    
                            ///gets full name from reverse geocoding
                        let l = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    l.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        placeName = "\(city), \(country)"
                        
                    }
                    }
                    }
                }
                Button("Update from Map"){ ///reverse geocoding, gets name from map center coordinates
                    let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                    location.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        placeName = "\(city), \(country)"
                        
                    }
                }
            }
            ///map
            Map(coordinateRegion: $region)
          
                HStack{
                    
                    Text("Latitude: ")
                  
                    TextField("", value: $latitude, format: .number).onSubmit{
                        region.center.latitude = latitude
            
                        isEdit.toggle()
                    }
                }
                
                HStack{
                    Text("Longtitude: ")
                    TextField("", value: $longtitude, format: .number).onSubmit{
                      
                        region.center.longitude = longtitude
                   
                    }
                
                }

            
        }
        .toolbar{
            ToolbarItem(placement:. navigationBarTrailing){
                EditButton()
            }
        }
        .environment(\.editMode, $mode) //attach var mode to edit mode of the environment
        .onReceive(timer){
            time in
          
            if x != region.center.latitude || y != region.center.longitude{
             
                latitude = region.center.latitude
                longtitude = region.center.longitude
    
            }
            x = region.center.latitude
            y = region.center.longitude
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .navigationBarItems(leading: btnBack)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(placeName)
            .padding(.leading)
            .padding(.trailing)
            .onAppear{
                ///sets placeName and coordinates for map
                placeName = place.name ?? ""
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
            }
            .onDisappear{
                ///update place name
                place.name = placeName
            }
            }
    }

