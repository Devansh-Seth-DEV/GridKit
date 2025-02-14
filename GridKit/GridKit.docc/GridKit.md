![GridKit Logo](GridKit/Resources/logo.jpg)

# GridKit Framework Documentation

## Overview

GridKit is a flexible and customizable grid-based UI framework for iOS, designed to help developers create dynamic layouts with ease. It provides a structured way to define grids, manage layouts, and handle interactions.

## Installation

To integrate GridKit into your project, you can use Swift Package Manager (SPM)
```sh
.package(url: "https://github.com/your-repo/GridKit.git", from: "1.0.0")
```
Alternatively, you can manually add the source files to your project.

## Components

### 1. `GKSpec`

`GKSpec` defines the specifications of the grid, including the number of rows, columns, and cell size.

**Properties:**
* `rows: Int` - Number of rows in the grid.
* `columns: Int` - Number of columns in the grid.
* `cellSize: CGFloat` - The size of each grid cell.
* `interCellInsets: CGFloat` - The spacing between the cells


### 2. `GKCanvas`

`GKCanvas` represents the main grid structure and handles cell layout and interactions.

**Methods:**

* `attachLayoutView(_ layoutView: GKLayoutView)` - Links the canvas to a layout view.
  
* `getSize() -> CGSize` - Returns the computed size of the canvas.
  
* `getCell(atRow row: Int, column: Int)` - Returns the cell at a given position.
  
* `getIndexPath(forCellAt point: CGPoint) -> IndexPath?` - Retrieves the index path of cell at a given touch point.
  
* `getCell(atPoint point: CGPoint) -> GKCell?` - Retrieves the cell at a given touch point.
  
* `getAllCells() -> [GKCell]` - Returns all the cells allocated in canvas.
  
* `layoutCanvasCells()` - Refreshes the canvas layout.
  
* `populate()` - Populates the grid with cells.
  
* `insertCell(atRow row: Int, column: Int)` - Inserts a cell in canvas at specific row and column.
  
* `removeCell(atRow row: Int, column: Int)` - Removes a cell from canvas at specific row and column.
  
* `erase()` - Clears the canvas.
  
* `hasCell(atRow row: Int, column: Int)` - Checks if the cell exists at given position.
  
* `updateCell(atRow row: Int, column: Int, update: (inout GKCell) -> Void)` - Updates the cell property at given position.

### 3. `GKCell`

A cell within the grid, which can be customized based on the application’s needs.

**Properties:**

* `row: Int` - The row index of the cell.

* `column: Int` - The column index of the cell.

* `view: UIView` - View of the cell


### 4. `GKLayoutView`

A UIView subclass that integrates with `GKCanvas` to display and manage grid layouts.

**Initializers:**
```swift
init(spec: GKSpec, in superview: UIView)
```

**Methods:**

* `resizeCanvas(to size: CGSize)` - Adjusts the canvas size dynamically.

* `populate()` - Populates the grid with cells.

* `eraseCanvas()` - Clears all cells from the grid.

## Usage Example

```swift
import GridKit

let gkspec = GKSpec(
    rows: 7,
    columns: 8,
    cellSize: 40,
    interCellInsets: 2,
    cellColor: .white,
    canvasColor: .clear,
    cellBorderWidth: 2,
    cellBorderColor: .systemTeal,
    cellCornerRadius: 8,
    canvasCornerRadius: 24
)

let gklayout = GKLayoutView(spec: gkspec, in: view)
gklayout.didCellTap = { cell in
    print("Tapped cell at row \(cell.row), column \(cell.column)")
}

gklayout.populate()

for row in 0..<gklayout.rows {
    for column in 0..<gklayout.columns {
        if (row == 0 && column < 4) ||
            ((row == 1 || row == 2) && (column < 2 || column == 3 || column > 4)) ||
            (row >= 3 && column > 5) ||
            (row == 4 && (column == 1 || column == 3 || column == 4)) ||
            (row == 5 && (column > 0 && column < 5)) ||
            (row == 6 && column == 1)
        {
            self.gklayout.canvas.removeCell(atRow: row, column: column)
        }
    }
}

```

## License

GridKit is available under the MIT license. See LICENSE for more details.
 
### Group

- `Symbol`: Represents a categorization of related components within GridKit.  
  - Example: `GKCell`, `GKCanvas`, `GKLayoutView` might be grouped under **Grid Elements**.
  - You can define groups such as **Core Structures**, **Layout Management**, **Utilities**, etc.

#### Example:
- **Grid Elements**: `GKCell`, `GKCanvas`, `GKLayoutView`
- **Specifications**: `GKSpec`
- **Interaction Handlers**: Tap gestures and event handlers.
