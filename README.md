# CGPathExt
Extract CGPathElement(s) from CGPath or CGMutablePath from Swift 

### Extracting path elements 
```.swift
let path = ... // CGPath or CGMutablePath

let pathElements = path.pathElements()
```

### PathElement 
Each path elements are defined as follows.

```.swift
public enum PathElement {
	case MoveToPoint(CGPoint)
	case AddLineToPoint(CGPoint)
	case AddQuadCurveToPoint(CGPoint, CGPoint)
	case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
	case CloseSubpath
}
```

### Code Sample
```.swift
import UIKit
import CoreGraphics

var bezier = UIBezierPath(ovalInRect: CGRectMake(0, 0, 400, 300))

let pathElements = bezier.CGPath.pathElements()
for pathElement in pathElements {
	switch pathElement {
	case .MoveToPoint(let pt): print("MoveToPoint: \(pt))")
	case .AddLineToPoint(let pt): print("AddLineToPoint: \(pt)")
	case .AddQuadCurveToPoint(let pt1, let pt2): print("AddQuadCurveToPoint: \(pt1),\(pt2)")
	case .AddCurveToPoint(let pt1, let pt2, let pt3): print("AddCurveToPoint: \(pt1), \(pt2), \(pt3)")
	case .CloseSubpath: print("CloseSubpath:")
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

### License
The MIT License (MIT)

Copyright (c) 2015 Digital Lynx Systems
