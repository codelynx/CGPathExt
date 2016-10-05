# CGPathExt

If you like to extract or to examine path components of the CGPath or CGMutablePath.  `CGPathExt` will help you to do that in Swift.  Since 'CGPath' is just an extension of CGPath, you may simply invoke  `pathElements()` against `CGPath`, then it will return the array of path elements.


### Extracting path elements 
```.swift
let path = ... // CGPath or CGMutablePath

let pathElements = path.pathElements()
```

### PathElement 
Each path elements are defined as follows.

```.swift
public enum PathElement {
	case moveToPoint(CGPoint)
	case addLineToPoint(CGPoint)
	case addQuadCurveToPoint(CGPoint, CGPoint)
	case addCurveToPoint(CGPoint, CGPoint, CGPoint)
	case closeSubpath
}
```

### Code Sample

Here is the sample code of how to examine each path elements in swift.

```.swift
import UIKit
import CoreGraphics

var bezier = UIBezierPath(ovalInRect: CGRectMake(0, 0, 400, 300))

let pathElements = bezier.CGPath.pathElements()
for pathElement in pathElements {
	switch pathElement {
	case .moveToPoint(let pt): print("MoveToPoint: \(pt))")
	case .addLineToPoint(let pt): print("AddLineToPoint: \(pt)")
	case .addQuadCurveToPoint(let pt1, let pt2): print("AddQuadCurveToPoint: \(pt1),\(pt2)")
	case .addCurveToPoint(let pt1, let pt2, let pt3): print("AddCurveToPoint: \(pt1), \(pt2), \(pt3)")
	case .closeSubpath: print("CloseSubpath:")
	}
}

```


### Result

```
MoveToPoint: (400.0, 150.0))
AddCurveToPoint: (400.0, 232.842712474619), (310.456949966159, 300.0), (200.0, 300.0)
AddCurveToPoint: (89.5430500338413, 300.0), (0.0, 232.842712474619), (0.0, 150.0)
AddCurveToPoint: (0.0, 67.157287525381), (89.5430500338413, 0.0), (200.0, 0.0)
AddCurveToPoint: (310.456949966159, 0.0), (400.0, 67.157287525381), (400.0, 150.0)
CloseSubpath:
```

### Swift Version

```.log
Xcode Version 8.0 (8A218a)
Apple Swift version 3.0 (swiftlang-800.0.46.2 clang-800.0.38)
```

### License
The MIT License (MIT)

Copyright (c) 2015 Electricwoods LLC, Digital Lynx Systems, Kaz Yoshikawa