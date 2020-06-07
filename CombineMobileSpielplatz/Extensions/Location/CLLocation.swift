//
//  CLLocation.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 31.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation

extension Double {
    var earthRadius: Double { 6378.137 }
}
extension CLLocation {

    ///
    ///Calculates the angle to another waypoint in degree (from geographical north).
    ///
    /// Parameter other: Other location
    ///
    /// Return angle in degree from geographical north
    
    func angle(to other: CLLocation) -> Double {
        if other === self {
            return 0
        }
        
        let coord = coordinate
        let coord2 = other.coordinate
        
        let lat1 = coord.latitude / 180 * Double.pi;
        let lon1 = coord.longitude / 180 * Double.pi;
        let lat2 = coord2.latitude / 180 * Double.pi;
        let lon2 = coord2.longitude / 180 * Double.pi;

        // RICHTUNG=ABS( ARCCOS( SIN(<LAT2>) / SIN(ARCCOS(<I5>)) / COS(<LAT1>) -
        // TAN(<LAT1>) / TAN(ARCCOS(I5)) ) * 180/PI()-J5)
        // I5=SIN(<LAT1>) * SIN(<LAT2>) + COS(<LAT1>) * COS(<LAT2>) *
        // COS((<LON1>-<LON2>))
        // J5=WENN(<LAT1>-<LAT2> <0 ; 0 ; 360)
        // TReal orth=sin_lat1 * sin_lat2 + cos_lat1 * cos_lat2 * cos_lon1_lon2;

        let sinLat1 = sin(lat1);
        let sinLat2 = sin(lat2);
        let cosLat1 = cos(lat1);
        let cosLat2 = cos(lat2);
        let tanLat1 = tan(lat1);
        let cosLon1Lon2 = cos(lon1 - lon2);

        // Calculate distance (Orthodrome)
        let orth = sinLat1 * sinLat2 + cosLat1 * cosLat2 * cosLon1Lon2;
        let acosOrth = acos(orth);

        // Calculate angle
        let sinAcosOrth = sin(acosOrth);
        let tanAcosOrth = tan(acosOrth);

        let acosA1 = acos(sinLat2 / sinAcosOrth / cosLat1 - tanLat1 / tanAcosOrth);
        let n: Double = (coord.latitude < coord2.longitude) ? 0 : 360;

        let angle = acosA1 * 180 / Double.pi - n;
        return (angle < 0) ? angle * -1 : angle;
    }
    
}
