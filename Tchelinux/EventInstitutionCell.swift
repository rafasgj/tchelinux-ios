//
//  EventInstitutionCell.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 23/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit
import MapKit

class EventInstitutionCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let right = UISwipeGestureRecognizer(target: self, action: #selector(self.mapTap))
            right.direction = .right
            mapView.addGestureRecognizer(right)
            let left = UISwipeGestureRecognizer(target: self, action: #selector(self.mapTap))
            left.direction = .left
            mapView.addGestureRecognizer(left)
        }
    }
    
    func mapTap() {
        if location != nil {
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region!.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region!.span)
            ]
            let placemark = MKPlacemark(coordinate: location!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Tchelinux"
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    var url: URL?

    var location: CLLocationCoordinate2D?
    let radius:CLLocationDistance = 1000 // in meters
    var region:MKCoordinateRegion? {
        if let l = location {
            return MKCoordinateRegionMakeWithDistance(l,radius,radius)
        }
        return nil
    }
    
    func setMapLocation(latitude: Double, longitude: Double) {
        // prevent scrolling.
        mapView.isScrollEnabled = false;
        mapView.isZoomEnabled = true;
        // event location
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // set region
        mapView.setRegion(region!, animated: true)
        // set pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = location!
        mapView.addAnnotation(annotation)
    }

    @IBAction func websiteButton(_ sender: UIButton) {
        if let site = url {
            UIApplication.shared.open(site, options: [:], completionHandler: nil)
        }
    }
}
