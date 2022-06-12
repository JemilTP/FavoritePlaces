//
//  MapView.swift
//  FavoritePlaces (iOS)
//
//  Created by Jemil Pepena on 25/5/2022.
//

import SwiftUI
import MapKit
import CoreLocation
struct Location: Identifiable{
    let id = UUID()
        let name: String
        var coordinate: CLLocationCoordinate2D
}

func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
   CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
   
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

struct MapView: View {

    @State var place: Place
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var latitude: Double 
    @State var longtitude: Double
    @State var location: Location = Location(name: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    @State var locations: [Location] = []
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var x: Double = 0.0
    @State var y: Double = 0.0
    @State var isEdit: Bool = false
    @State var mode: EditMode = .inactive
    @State var placeName: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
    
    
    var body: some View {
        VStack{
            if mode == .active{
                TextField("Place", text: $placeName).onSubmit{
                    if placeName != ""{
                    getCoordinateFrom(address: placeName) { coordinate, error in
                        guard let coordinate = coordinate, error == nil else { return }
                        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

                    }
                    }
                }
                Button("Update from Map"){
                    let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                    location.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        placeName = "\(city), \(country)"
                        
                    }
                }
            }
          
            Map(coordinateRegion: $region
                ,annotationItems: locations){
                
                location in
                MapAnnotation(coordinate: location.coordinate){
                    Circle()
                        .fill(.red)
                        
                }
            }
          
                HStack{
                    
                    Text("Latitude: ")
                  
                    TextField("", value: $latitude, format: .number).onSubmit{
                        region.center.latitude = latitude
                       
                        locations[0].coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
                        isEdit.toggle()
                    }
                }
                
                HStack{
                    Text("Longtitude: ")
                    TextField("", value: $longtitude, format: .number).onSubmit{
                      
                        region.center.longitude = longtitude
                   
                        locations[0].coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                     
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
                placeName = place.name ?? ""
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
             
                location.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longtitude)
                locations = [location]
            }
            .onDisappear{
                place.name = placeName
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
