![GridKit Logo](https://github.com/Devansh-Seth-DEV/GridKit/blob/main/GridKit/GridKit.docc/Resources/logo.jpg)


# GridKit Framework Documentation

## Overview

GridKit is a flexible and customizable grid-based UI framework for iOS, designed to help developers create dynamic layouts with ease. It provides a structured way to define grids, manage layouts, and handle interactions.

## Installation

![Install Framework](https://img.shields.io/badge/Install-GridKit-brightgreen?style=for-the-badge)

Install the framework
```sh
curl -sSL https://gist.githubusercontent.com/Devansh-Seth-DEV/c1ea5abd3272cd166d4bf0e10683a7a7/raw/0eb227eacc44373a6fb59c4e9ac49696015fdda9/gk_install.sh | bash
```


![Integrate Framework](https://img.shields.io/badge/Integrate-GridKit-brightgreen?style=for-the-badge)

To integrate **GridKit** into your project, you can Embed and Link the Framework
1. Select your project in Xcode.
2. Go to the Target → General tab.
3. Scroll down to Frameworks, Libraries, and Embedded Content.
4. Click the + button and add **GridKit XCFramework**.
5. Set Embed to "Embed & Sign".

## Components

### 1. GKSpec

`GKSpec` defines the specifications of the grid, including the number of rows, columns, and cell size.

**Properties:**
* `rows: Int` - Number of rows in the grid.
* `columns: Int` - Number of columns in the grid.
* `cellSize: CGFloat` - The size of each grid cell.
* `interCellInsets: CGFloat` - The spacing between the cells


### 2. GKCanvas

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

* `populateCells(at indexes: [(row: Int, col: Int)])` - Populates the grid with the given positions

* `populateCells(if condition: ((Int, Int) -> Bool))` - Populates the grid at row and column in the condition if it satisfies
  
* `insertCell(atRow row: Int, column: Int)` - Inserts a cell in canvas at specific row and column.
  
* `removeCell(atRow row: Int, column: Int)` - Removes a cell from canvas at specific row and column.

* `removeCells(at indexes: [(row: Int, col: Int)])` - Removes the cell from the grid with the given positions

* `removeCells(if condition: ((Int, Int) -> Bool))` - Removes the cell from the grid at row and column in the condition if it satisfies
  
* `erase()` - Clears the canvas.
  
* `hasCell(atRow row: Int, column: Int)` - Checks if the cell exists at given position.
  
* `updateCell(atRow row: Int, column: Int, update: (inout GKCell) -> Void)` - Updates the cell property at given position.

### 3. GKCell

A cell within the grid, which can be customized based on the application’s needs.

**Properties:**

* `row: Int` - The row index of the cell.

* `column: Int` - The column index of the cell.

* `view: UIView` - View of the cell


### 4. GKLayoutView

A UIView subclass that integrates with `GKCanvas` to display and manage grid layouts.

**Initializers:**
```swift
init(
    spec: GKSpec,               //GK Specifications of layout view
    in superview: UIView,       //View in which layout is placed
    masksToBounds: Bool = true  //Property which make sure layout size always bounds under superview size
)
```


**Properties:**

* `allowPathDrawing` - A boolean property to activate the path drawing on touching the cell

* `didTapCell` - Closure to call when a cell is tapped, gets called only if `allowPathDrawing` is set to `false`) 

* `pathLineWidth: CGFloat` - Width of the path line

* `pathStrokeColor: UIColor?` - Path Stroke Color when drawing the path

* `pathLayers: [CAShapeLayer]` - Array of traced path when a cell gets traced

* `tracedCells: [IndexPath]` - Store all the cells which are traced

* `updateCellOnTrace: ((GKCell) -> Void)?` - Closure to call when cells are traced while drawing the path (touch move)

* `updateCellOnTraceEnd: ((GKCell) -> Void)?` - Closre to call when lift up the touch from the screen (touch end)


**Methods:**

* `resizeCanvas(to size: CGSize)` - Adjusts the canvas size dynamically.

* `populate()` - Calls GKCanvas `populate()` method

* `populateCells(at indexes: [(row: Int, col: Int)])` - Calls GKCanvas `populateCells(at:)` method

* `populateCells(if condition: ((Int, Int) -> Bool))` - Calls GKCanvas `populateCells(if:)` method

* `removeCell(atRow row: Int, column: Int)` - Calls GKCanvas `removeCell(atRow:column)` method

* `removeCells(at indexes: [(row: Int, col: Int)])` - Calls GKCanvas `removeCells(at:)` method

* `removeCells(if condition: ((Int, Int) -> Bool))` - Calls GKCanvas `removeCells(if:)` method

* `eraseCanvas()` - Calls GKCanvas `erase()` method


## Usage Example

```swift
import UIKit
import GridKit

override func viewDidLoad() {
  super.viewDidLoad()

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
  gklayout.allowPathDrawing = true
          
  gklayout.updateCellOnTrace = { cell in
    cell.view.backgroundColor = gklayout.pathStrokeColor?.withAlphaComponent(0.5)
  }
  gklayout.updateCellOnTraceEnd = { cell in
    cell.view.backgroundColor = gklayout.canvas.gkspec.cellColor
  }
          
  gklayout.populate()
          
  gklayout.removeCells(if: { (row, column) in
    return (
      (row == 0 && column < 4) ||
      ((row == 1 || row == 2) && (column < 2 || column == 3 || column > 4)) ||
      (row >= 3 && column > 5) ||
      (row == 4 && (column == 1 || column == 3 || column == 4)) ||
      (row == 5 && (column > 0 && column < 5)) ||
      (row == 6 && column == 1)
    )
  })
}
```

## DEMO
![Demo](https://github.com/Devansh-Seth-DEV/GridKit/blob/main/GridKit/GridKit.docc/Resources/demo.gif)

## License

GridKit is available under the MIT license. See [LICENSE](LICENSE) for more details.
 
### Group

- `Symbol`: Represents a categorization of related components within GridKit.  
  - Example: `GKCell`, `GKCanvas`, `GKLayoutView` might be grouped under **Grid Elements**.
  - You can define groups such as **Core Structures**, **Layout Management**, **Utilities**, etc.

#### Example:
- **Grid Elements**: `GKCell`, `GKCanvas`, `GKLayoutView`
- **Specifications**: `GKSpec`
- **Interaction Handlers**: Tap gestures and event handlers.
