//
//  GridKitTests.swift
//  GridKitTests
//
//  Created by Devansh Seth on 12/02/25.
//

import XCTest
@testable import GridKit

final class GridKitTests: XCTestCase {
    func testGridViewInitialization() throws {
        // Create a sample configuration
        let spec = GKSpec(rows: 3, columns: 3, cellSize: 50)
        
        let gridView =  UIView(
            frame: CGRect(
                x: 0, y: 0, width: 500, height: 500
                )
            )
        // Initialize GridView
        let gklayout = GKLayoutView(
            spec: spec,
            in: gridView
        )

        // Assert that GridView size matches calculated grid size
        XCTAssertEqual(gklayout.frame.size, CGSize(width: 150, height: 150), "Layout view size should match grid specifications")
    }
    
    func testGridBlockTap() throws {
        let gkspec = GKSpec(rows: 3, columns: 3, cellSize: 50)
        let gridView =  UIView(
            frame: CGRect(
                x: 0, y: 0, width: 500, height: 500
                )
            )
        let gklayout = GKLayoutView(spec: gkspec, in: gridView)
        
        gklayout.canvas.insertCell(atRow: 0, column: 0)
        // Create expectation for async tap handling
        let expectation = XCTestExpectation(description: "Grid Cell tap should be detected")

        // Assign a closure to handle taps
        gklayout.didTapCell = { cell in
            print("Grid Cell tapped!")
            XCTAssertNotNil(cell, "Tapped cell should not be nil")
            expectation.fulfill()
        }

        // Simulate a tap on a known position (first block)
        let tapLocation = CGPoint(x: 2, y: 2)  // Inside the first block
        let tapGesture = UITapGestureRecognizer()
        tapGesture.setValue(tapLocation, forKey: "locationInView")
        gklayout.perform(#selector(gklayout.handleCellTap(_:)), with: tapGesture)

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGridSizeCalculation() throws {
        let gkspec = GKSpec(rows: 4, columns: 5, cellSize: 40)
        let gridView =  UIView(
            frame: CGRect(
                x: 0, y: 0, width: 500, height: 500
                )
            )
        let gklayout = GKLayoutView(spec: gkspec, in: gridView)
        let calculatedSize = gklayout.canvas.getSize()
        XCTAssertEqual(calculatedSize, CGSize(width: 200, height: 160), "Canvas size calculation is incorrect")
    }
    
    func testGridRenderingPerformance() throws {
        let gkspec = GKSpec(rows: 10, columns: 10, cellSize: 40)
        let gridView =  UIView(
            frame: CGRect(
                x: 0, y: 0, width: 500, height: 500
                )
            )
        self.measure {
            let gklayout = GKLayoutView(spec: gkspec, in: gridView)
            gklayout.populate()
        }
    }

}
