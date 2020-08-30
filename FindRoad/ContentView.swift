//
//  ContentView.swift
//  FindRoad
//
//  Created by Yermek Sabyrzhan on 8/30/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!

    var body: some View{
        ZStack{
            
            VStack(spacing: 0){
                HStack{
                    Text("Pick a location")
                        .font(.title)
                    Spacer()
                }.padding()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color.white )
                MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination)
                    .onAppear {
                        self.manager.requestAlwaysAuthorization() 
                }
            }
        }
        
    }
}

struct MapView : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    @Binding var map : MKMapView
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        manager.delegate = context.coordinator
        map.showsUserLocation = true
                return map
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
 
    }
    class Coordinator : NSObject, MKMapViewDelegate, CLLocationManagerDelegate{
        var parent : MapView
        init(parent1 : MapView){
            parent = parent1
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied{
                self.parent.alert.toggle()
            }
            else{
                self.parent.manager.startUpdatingLocation()
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.parent.source = locations.last!.coordinate
        }
    }
}
