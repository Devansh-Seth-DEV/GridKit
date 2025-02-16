//
//  GKSpec.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

public struct GKSpec {
    /// Defines Maximun number of rows in a canvas
    public var rows: Int
    /// Defines Maximum number of columns in a canvas
    public var columns: Int
    /// Defines the size of a single cell in a canvas
    public var cellSize: CGFloat
    /// Defines the spacing between two cells in a canvas either horizontally or vertically, default is set to `0`
    public var interCellInsets: CGFloat
    /// Defines the backgound color of the cell, default is set to `tertiarySystemGroupedBackground` color
    public var cellColor: UIColor?
    /// Defines the background color of the canvas, default is set to `white`
    public var canvasColor: UIColor?
    /// Defines the border width of the cell in canvas, default is set to `nil`
    public var cellBorderWidth: CGFloat?
    /// Defines the border color of the cell in canvas, default is set to `black`
    public var cellBorderColor: UIColor?
    /// Defines the corner radius of a cell in canvas, default is set to `nil`
    public var cellCornerRadius: CGFloat?
    /// Defines the corner radius of canvas, deafult is set to `nil`
    public var canvasCornerRadius: CGFloat?
    
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
    
    /// Computes the total grid width based on the cell size and spacing between the cells.
    public var canvasWidth: CGFloat {
        return (CGFloat(columns) * cellSize) + (CGFloat(columns - 1) * interCellInsets)
    }

    /// Computes the total grid height based on the cell size and spacing between the cells.
    public var canvasHeight: CGFloat {
        return (CGFloat(rows) * cellSize) + (CGFloat(rows - 1) * interCellInsets)
    }
}
