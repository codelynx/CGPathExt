//
//  CGPathRef+Z.swift [swift2.0]
//  ZKit
//
//  Created by Kaz Yoshikawa on 10/8/15.
//  Copyright © 2015 Electricwoods LLC. All rights reserved.
//
//


import Foundation
import CoreGraphics

//
//	PathElement
//

enum PathElement {
	case MoveToPoint(CGPoint)
	case AddLineToPoint(CGPoint)
	case AddQuadCurveToPoint(CGPoint, CGPoint)
	case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
	case CloseSubpath
}

internal class Info {
	var pathElements = [PathElement]()
}


//
//	CGPathRef
//

extension CGPathRef {

	func pathElements() -> [PathElement] {
		var info = Info()

		CGPathApply(self, &info) { (info, element) -> Void in
			var info = UnsafeMutablePointer<Info>(info)
			switch element.memory.type {
			case .MoveToPoint:
				let pt = element.memory.points[0]
				info.memory.pathElements.append(PathElement.MoveToPoint(pt))
				//print("MoveToPoint \(pt)")
			case .AddLineToPoint:
				let pt = element.memory.points[0]
				info.memory.pathElements.append(PathElement.AddLineToPoint(pt))
				//print("AddLineToPoint \(pt)")
			case .AddQuadCurveToPoint:
				let pt1 = element.memory.points[0]
				let pt2 = element.memory.points[1]
				info.memory.pathElements.append(PathElement.AddQuadCurveToPoint(pt1, pt2))
				//print("AddQuadCurveToPoint \(pt1) \(pt2)")
			case .AddCurveToPoint:
				let pt1 = element.memory.points[0]
				let pt2 = element.memory.points[1]
				let pt3 = element.memory.points[2]
				info.memory.pathElements.append(PathElement.AddCurveToPoint(pt1, pt2, pt3))
				//print("AddCurveToPoint \(pt1) \(pt2) \(pt3)")
			case .CloseSubpath:
				info.memory.pathElements.append(PathElement.CloseSubpath)
				//print("CloseSubpath")
			}
		}

		return info.pathElements
	}

}

//
//	operator ==
//

func == (lhs: PathElement, rhs: PathElement) -> Bool {
	switch (lhs, rhs) {
	case (.MoveToPoint(let a), .MoveToPoint(let b)):
		return CGPointEqualToPoint(a, b)
	case (.AddLineToPoint(let a), .AddLineToPoint(let b)):
		return CGPointEqualToPoint(a, b)
	case (.AddQuadCurveToPoint(let a1, let a2), .AddQuadCurveToPoint(let b1, let b2)):
		return CGPointEqualToPoint(a1, b1) && CGPointEqualToPoint(a2, b2)
	case (.AddCurveToPoint(let a1, let a2, let a3), .AddCurveToPoint(let b1, let b2, let b3)):
		return CGPointEqualToPoint(a1, b1) && CGPointEqualToPoint(a2, b2) && CGPointEqualToPoint(a3, b3)
	case (.CloseSubpath, .CloseSubpath):
		return true
	default:
		return false
	}
}


