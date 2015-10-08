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
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	

	func testPathElementEqualOperator() {
	
		// element type: MoveToPoint
		let mov1 = PathElement.MoveToPoint(CGPointMake(100, 200))
		let mov1b = PathElement.MoveToPoint(CGPointMake(100, 200))
		XCTAssert(mov1 == mov1b)

		// parameter order difference
		let mov2 = PathElement.MoveToPoint(CGPointMake(100, 0))
		let mov3 = PathElement.MoveToPoint(CGPointMake(0, 100))
		XCTAssertFalse(mov1 == mov2)
		XCTAssertFalse(mov1 == mov3)

		// element type: AddLineToPoint
		let addL1 = PathElement.AddLineToPoint(CGPointMake(100, 200))
		let addL1b = PathElement.AddLineToPoint(CGPointMake(100, 200))
		XCTAssertFalse(mov1 == addL1)
		XCTAssert(addL1 == addL1b)

		// parameter order difference
		let addL2 = PathElement.AddLineToPoint(CGPointMake(300, 400))
		let addL3 = PathElement.AddLineToPoint(CGPointMake(400, 300))
		XCTAssertFalse(addL1 == addL2)
		XCTAssertFalse(addL2 == addL3)

		// element type: AddQuadCurveToPoint
		let addQ1 = PathElement.AddQuadCurveToPoint(CGPointMake(110, 120), CGPointMake(210, 220))
		let addQ1b = PathElement.AddQuadCurveToPoint(CGPointMake(110, 120), CGPointMake(210, 220))
		let addQ2 = PathElement.AddQuadCurveToPoint(CGPointMake(310, 320), CGPointMake(410, 420))
		let addQ3 = PathElement.AddQuadCurveToPoint(CGPointMake(410, 420), CGPointMake(310, 320))
		XCTAssert(addQ1 == addQ1b)
		XCTAssertFalse(addQ1 == addQ2)
		XCTAssertFalse(addQ1 == addQ2)
		XCTAssertFalse(addQ2 == addQ3)

		// element type: AddCurveToPoint
		let addC1 = PathElement.AddCurveToPoint(CGPointMake(110, 120), CGPointMake(210, 220), CGPointMake(310, 320))
		let addC1b = PathElement.AddCurveToPoint(CGPointMake(110, 120), CGPointMake(210, 220), CGPointMake(310, 320))
		let addC2 = PathElement.AddCurveToPoint(CGPointMake(400, 410), CGPointMake(500, 510), CGPointMake(600, 610))
		let addC3 = PathElement.AddCurveToPoint(CGPointMake(500, 510), CGPointMake(600, 610), CGPointMake(400, 410))
		let addC4 = PathElement.AddCurveToPoint(CGPointMake(600, 610), CGPointMake(400, 410), CGPointMake(500, 510))
		XCTAssert(addC1 == addC1b)
		XCTAssertFalse(addC2 == addC3)
		XCTAssertFalse(addC2 == addC4)
		XCTAssertFalse(addC3 == addC4)

		// element type: CloseSubpath
		let close1 = PathElement.CloseSubpath
		let close1b = PathElement.CloseSubpath
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

		let pt1 = CGPointMake(100, 200)
		let pt2 = CGPointMake(100, 300)
		let pt3c = CGPointMake(200, 350)
		let pt4 = CGPointMake(300, 300)
		let pt5a = CGPointMake(350, 275)
		let pt6b = CGPointMake(350, 225)
		let pt7 = CGPointMake(300, 200)

		// expected results
		let expected: [PathElement] = [
			PathElement.MoveToPoint(pt1),
			PathElement.AddLineToPoint(pt2),
			PathElement.AddQuadCurveToPoint(pt3c, pt4),
			PathElement.AddCurveToPoint(pt5a, pt6b, pt7),
			PathElement.CloseSubpath
		]

		// build a path
		let path = CGPathCreateMutable()
		CGPathMoveToPoint(path, nil, pt1.x, pt1.y)
		CGPathAddLineToPoint(path, nil, pt2.x, pt2.y)
		CGPathAddQuadCurveToPoint(path, nil, pt3c.x, pt3c.y, pt4.x, pt4.y)
		CGPathAddCurveToPoint(path, nil, pt5a.x, pt5a.y, pt6b.x, pt6b.y, pt7.x, pt7.y)
		CGPathCloseSubpath(path)

		// against CGMutablePath
		let pathElements = path.pathElements()
		XCTAssert(pathElements.count == expected.count)
		for (index, element) in pathElements.enumerate() {
			XCTAssert(element == expected[index])
		}

		// against CGPath
		if let path2 = CGPathCreateCopy(path) {
			let pathElements2 = path2.pathElements()
			XCTAssert(pathElements2.count == expected.count)
			for (index, element) in pathElements.enumerate() {
				XCTAssert(element == expected[index])
			}
		}

	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			// Put the code you want to measure the time of here.
		}
	}
	
}
