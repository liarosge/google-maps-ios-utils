#import <CoreText/CoreText.h>
#import "GDefaultClusterRenderer.h"
#import "GQuadItem.h"
#import "GCluster.h"

@implementation GDefaultClusterRenderer {
    GMSMapView *_map;
    NSMutableArray *_markerCache;
}

- (id)initWithMapView:(GMSMapView*)googleMap {
    if (self = [super init]) {
        _map = googleMap;
        _markerCache = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clustersChanged:(NSSet*)clusters {
    for (GMSMarker *marker in _markerCache) {
        marker.map = nil;
    }
    
    [_markerCache removeAllObjects];
    
    for (id <GCluster> cluster in clusters) {
        GMSMarker *marker;
        marker = [[GMSMarker alloc] init];
        [_markerCache addObject:marker];
        
        NSUInteger count = cluster.items.count;
        if (count > 1) {
            marker.icon = [self generateClusterIconWithCount:count];
        }
        else {
            marker.icon = cluster.marker.icon;
        }
        if(count == 1){
            marker.title = cluster.marker.title;
            marker.tappable = YES;
        }
        else{
            marker.tappable = NO;
        }
        marker.userData = cluster.marker.userData;
        
        marker.position = cluster.marker.position;
        marker.map = _map;
    }
}

+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
//    CGContextSetFillColorWithColor([UIColor clearColor].CGColor);
//    CGContextSetfil
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    CGFloat fontSize = image.size.height*12.0/52.0;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        NSDictionary *att = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]};
        [text drawInRect:rect withAttributes:att];
    }
    else
    {
        //legacy support
        [text drawInRect:CGRectIntegral(rect) withFont:font];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)generateClusterIconWithCount:(NSUInteger)count {
//    if (count < 10) {
    UIImage *icon;
    if(count < 5){
        icon = [UIImage imageNamed:@"m1.png"];
    }
    else if(count < 10){
        icon = [UIImage imageNamed:@"m2.png"];
    }
    else if(count < 50){
        icon = [UIImage imageNamed:@"m3.png"];
    }
    else if(count < 99){
        icon = [UIImage imageNamed:@"m4.png"];
    }
    else{
        icon = [UIImage imageNamed:@"m5.png"];
    }
    CGFloat iconHeight = icon.size.height;
    if(count > 999){
        icon = [GDefaultClusterRenderer drawText:[NSString stringWithFormat:@"999"] inImage:icon atPoint:CGPointMake(0, iconHeight/2.66)];
    }
    else
        icon = [GDefaultClusterRenderer drawText:[NSString stringWithFormat:@"%d",count] inImage:icon atPoint:CGPointMake(0, iconHeight/2.66)];
    return icon;
//    }
//    else if(count < )
    
//    int diameter = 30;
//    float inset = 2;
//    
//    CGRect rect = CGRectMake(0, 0, diameter, diameter);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    // set stroking color and draw circle
//    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] setStroke];
//    
//    if (count > 100) [[UIColor orangeColor] setFill];
//    else if (count > 10) [[UIColor yellowColor] setFill];
//    else [[UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:255.0/255.0 alpha:1] setFill];
//
//    CGContextSetLineWidth(ctx, inset);
//
//    // make circle rect 5 px from border
//    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
//    circleRect = CGRectInset(circleRect, inset, inset);
//
//    // draw circle
//    CGContextFillEllipseInRect(ctx, circleRect);
//    CGContextStrokeEllipseInRect(ctx, circleRect);
//
//    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)@"Helvetica-Bold", 12.0f, NULL);
//    
//    UIColor *fontColor;
//    if ((count <= 100) && count > 10) fontColor = [UIColor blackColor];
//    else fontColor = [UIColor whiteColor];
//    
//    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
//            (__bridge id)myFont, (id)kCTFontAttributeName,
//                    fontColor, (id)kCTForegroundColorAttributeName, nil];
//
//    // create a naked string
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    NSNumber *countNumber = [NSNumber numberWithUnsignedInteger:count];
//    NSString *string = [formatter stringFromNumber:countNumber];
//
//    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string
//                                                                       attributes:attributesDict];
//
//    // flip the coordinate system
//    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
//    CGContextTranslateCTM(ctx, 0, diameter);
//    CGContextScaleCTM(ctx, 1.0, -1.0);
//
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(stringToDraw));
//    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
//                                                                        frameSetter, /* Framesetter */
//                                                                        CFRangeMake(0, stringToDraw.length), /* String range (entire string) */
//                                                                        NULL, /* Frame attributes */
//                                                                        CGSizeMake(diameter, diameter), /* Constraints (CGFLOAT_MAX indicates unconstrained) */
//                                                                        NULL /* Gives the range of string that fits into the constraints, doesn't matter in your situation */
//                                                                        );
//    CFRelease(frameSetter);
//    
//    //Get the position on the y axis
//    float midHeight = diameter;
//    midHeight -= suggestedSize.height;
//    
//    float midWidth = diameter / 2;
//    midWidth -= suggestedSize.width / 2;
//
//    CTLineRef line = CTLineCreateWithAttributedString(
//            (__bridge CFAttributedStringRef)stringToDraw);
//    CGContextSetTextPosition(ctx, midWidth, 12);
//    CTLineDraw(line, ctx);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
}

@end
