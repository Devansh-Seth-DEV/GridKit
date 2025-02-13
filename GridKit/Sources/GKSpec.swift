//
//  GridConfig.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

public struct GKSpec {
    public var rows: Int        // Max Rows in a grid
    public var columns: Int     // Max Columns in a grid
    
    public var cellSize: CGFloat    // Size of single cell(unit size), size is considers same for width and height
    public var interCellInsets: CGFloat // Inter cell spacing
    
    public var cellColor: UIColor?      // Background color of cell
    public var canvasColor: UIColor?    // Backgournd color of canvas
    public var cellBorderWidth: CGFloat?    // Border width of cell
    public var cellBorderColor: UIColor?    // Border color of cell
    public var cellCornerRadius: CGFloat?   // Corner radius of cell
    public var canvasCornerRadius: CGFloat? // Corner radius of canvas
    
    // Initializes the configuration for the grid
    public init(
        rows: Int,
        columns: Int,
        cellSize: CGFloat,
        interCellInsets: CGFloat = 0,
        cellColor: UIColor? = UIColor.tertiarySystemGroupedBackground,
        canvasColor: UIColor? = UIColor.white,
        cellBorderWidth: CGFloat? = nil,
        cellBorderColor: UIColor? = UIColor.black,
        cellCornerRadius: CGFloat? = nil,
        canvasCornerRadius: CGFloat? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if rows < 0 || columns < 0 {
            preconditionFailure("GridConfig has invalid values! (rows: \(rows), columns: \(columns))\nWarning occurred in file: \(file), line: \(line)")
        }
        
        if cellSize < 0 {
            preconditionFailure("blockSize cannot be negative! Found: \(cellSize)\nFile: \(file), Line: \(line)")
        }
        
        self.rows = rows
        self.columns = columns
        self.cellSize = cellSize
        self.interCellInsets = interCellInsets
        
        self.cellColor = cellColor
        self.canvasColor = canvasColor
        self.cellBorderWidth = cellBorderWidth
        self.cellBorderColor = cellBorderColor
        self.cellCornerRadius = cellCornerRadius
        self.canvasCornerRadius = canvasCornerRadius
    }
    
    // Computes the total grid width based on the cell size and spacing between the cells.
    public var canvasWidth: CGFloat {
        return (CGFloat(columns) * cellSize) + (CGFloat(columns - 1) * interCellInsets)
    }

    // Computes the total grid height based on the cell size and spacing between the cells.
    public var canvasHeight: CGFloat {
        return (CGFloat(rows) * cellSize) + (CGFloat(rows - 1) * interCellInsets)
    }
}
