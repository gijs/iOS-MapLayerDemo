#import "CDistrictsTileOverlay.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation CDistrictsTileOverlay
@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize defaultAlpha;

-(id) init {
    self = [super init];
    
    defaultAlpha = 1.0f;
    
    // I am still not well-versed in map projections, but the Google Mercator projection
    // is slightly off from the "standard" Mercator projection, used by MapKit. (GMerc is used
    // by the demo tileserver to serve to the Google Maps API script in a user's
    // browser.)
    //
    // My understanding is that this is due to Google Maps' use of a Spherical Mercator
    // projection, where the poles are cut off -- the effective map ending at approx. +/- 85º.
    // MapKit does not(?), therefore, our origin point (top-left) must be moved accordingly.
    
    boundingMapRect = MKMapRectWorld;
    boundingMapRect.origin.x += 1048600.0;
    boundingMapRect.origin.y += 1048600.0;
    
    coordinate = CLLocationCoordinate2DMake(0, 0);
    
    return self;
}

- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
    // The MapBox JS API helper ( http://js.mapbox.com/g/2/mapbox.js ) notes that the
    // "Y coordinate is flipped in Mapbox, compared to Google" and provides this conversion:
    NSUInteger newY = abs(y - (pow(2,zoomLevel) - 1));
    
    return [NSString stringWithFormat:@"http://b.tile.mapbox.com/1.0.0/congressional-districts-110/%d/%d/%d.png",zoomLevel,x,newY];
}
@end
