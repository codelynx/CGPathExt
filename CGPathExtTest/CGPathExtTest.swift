//
//	CGPathExtTest.swift
//	CGPathExtTest
//
//	Created by Kaz Yoshikawa on 10/8/15.
//
//

import XCTest
import CoreGraphics

class CGPathExtTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	

	func testPathElementEqualOperator() {
	
		// element type: MoveToPoint
		let mov1 = PathElement.moveToPoint(CGPoint(x: 100, y: 200))
		let mov1b = PathElement.moveToPoint(CGPoint(x: 100, y: 200))
		XCTAssert(mov1 == mov1b)

		// parameter order difference
		let mov2 = PathElement.moveToPoint(CGPoint(x: 100, y: 0))
		let mov3 = PathElement.moveToPoint(CGPoint(x: 0, y: 100))
		XCTAssertFalse(mov1 == mov2)
		XCTAssertFalse(mov1 == mov3)

		// element type: AddLineToPoint
		let addL1 = PathElement.addLineToPoint(CGPoint(x: 100, y: 200))
		let addL1b = PathElement.addLineToPoint(CGPoint(x: 100, y: 200))
		XCTAssertFalse(mov1 == addL1)
		XCTAssert(addL1 == addL1b)

		// parameter order difference
		let addL2 = PathElement.addLineToPoint(CGPoint(x: 300, y: 400))
		let addL3 = PathElement.addLineToPoint(CGPoint(x: 400, y: 300))
		XCTAssertFalse(addL1 == addL2)
		XCTAssertFalse(addL2 == addL3)

		// element type: AddQuadCurveToPoint
		let addQ1 = PathElement.addQuadCurveToPoint(CGPoint(x: 110, y: 120), CGPoint(x: 210, y: 220))
		let addQ1b = PathElement.addQuadCurveToPoint(CGPoint(x: 110, y: 120), CGPoint(x: 210, y: 220))
		let addQ2 = PathElement.addQuadCurveToPoint(CGPoint(x: 310, y: 320), CGPoint(x: 410, y: 420))
		let addQ3 = PathElement.addQuadCurveToPoint(CGPoint(x: 410, y: 420), CGPoint(x: 310, y: 320))
		XCTAssert(addQ1 == addQ1b)
		XCTAssertFalse(addQ1 == addQ2)
		XCTAssertFalse(addQ1 == addQ2)
		XCTAssertFalse(addQ2 == addQ3)

		// element type: AddCurveToPoint
		let addC1 = PathElement.addCurveToPoint(CGPoint(x: 110, y: 120), CGPoint(x: 210, y: 220), CGPoint(x: 310, y: 320))
		let addC1b = PathElement.addCurveToPoint(CGPoint(x: 110, y: 120), CGPoint(x: 210, y: 220), CGPoint(x: 310, y: 320))
		let addC2 = PathElement.addCurveToPoint(CGPoint(x: 400, y: 410), CGPoint(x: 500, y: 510), CGPoint(x: 600, y: 610))
		let addC3 = PathElement.addCurveToPoint(CGPoint(x: 500, y: 510), CGPoint(x: 600, y: 610), CGPoint(x: 400, y: 410))
		let addC4 = PathElement.addCurveToPoint(CGPoint(x: 600, y: 610), CGPoint(x: 400, y: 410), CGPoint(x: 500, y: 510))
		XCTAssert(addC1 == addC1b)
		XCTAssertFalse(addC2 == addC3)
		XCTAssertFalse(addC2 == addC4)
		XCTAssertFalse(addC3 == addC4)

		// element type: CloseSubpath
		let close1 = PathElement.closeSubpath
		let close1b = PathElement.closeSubpath
		XCTAssert(close1 == close1b)

		// convination
		XCTAssertFalse(mov1 == addL1)
		XCTAssertFalse(mov1 == addQ1)
		XCTAssertFalse(mov1 == addC1)
		XCTAssertFalse(mov1 == close1)

		XCTAssertFalse(addL1 == addQ1)
		XCTAssertFalse(addL1 == addC1)
		XCTAssertFalse(addL1 == close1)

		XCTAssertFalse(addQ1 == addC1)
		XCTAssertFalse(addQ1 == close1)

	}

	func testPathElementBasic() {

		let pt1 = CGPoint(x: 100, y: 200)
		let pt2 = CGPoint(x: 100, y: 300)
		let pt3c = CGPoint(x: 200, y: 350)
		let pt4 = CGPoint(x: 300, y: 300)

		let pt5a = CGPoint(x: 350, y: 275)
		let pt6b = CGPoint(x: 350, y: 225)
		let pt7 = CGPoint(x: 300, y: 200)

		// expected results
		let expected: [PathElement] = [
			PathElement.moveToPoint(pt1),
			PathElement.addLineToPoint(pt2),
			PathElement.addQuadCurveToPoint(pt3c, pt4),
			PathElement.addCurveToPoint(pt5a, pt6b, pt7),
			PathElement.closeSubpath
		]

		// build a path
		let path = CGMutablePath()
		path.move(to: pt1)
		path.addLine(to: pt2)
		path.addQuadCurve(to: pt3c, control: pt4)
		path.addCurve(to: pt5a, control1: pt6b, control2: pt7)
		path.closeSubpath()

		// against CGMutablePath
		let pathElements = path.pathElements()
		XCTAssert(pathElements.count == expected.count)
		for (index, element) in pathElements.enumerated() {
			switch index {
			case 0:
				if case .moveToPoint(let p0) = element { XCTAssert(p0 == pt1) }
				else { XCTAssert(false) }
			case 1:
				if case .addLineToPoint(let p0) = element { XCTAssert(p0 == pt2) }
				else { XCTAssert(false) }
			case 2:
				if case .addQuadCurveToPoint(let p0, let p1) = element { XCTAssert(p0 == pt4 && p1 == pt3c) }
				else { XCTAssert(false) }
			case 3:
				if case .addCurveToPoint(let p0, let p1, let p2) = element {
					print("\(p0), \(p1), \(p2)")
					XCTAssert(p0 == pt6b)
					XCTAssert(p1 == pt7)
					XCTAssert(p2 == pt5a)
				}
				else { XCTAssert(false) }
			case 4:
				if case .closeSubpath = element { XCTAssert(true) }
				else { XCTAssert(false) }
			default:
				XCTAssert(false)
			}
		}

	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		//self.measure {
			// Put the code you want to measure the time of here.
		//}
	}
	
}
