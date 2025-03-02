![GridKit Logo](https://github.com/Devansh-Seth-DEV/GridKit-DevSource/blob/main/GridKit/GridKit.docc/Resources/logo.jpg)


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

## Topics
### Classes
- [GKCell](#gkcell)
- [GKCanvas](#gkcanvas)
- [GKLayoutView](#gklayoutview)

### Structures
- [GKSpec](#gkspec)

### Getting Started
- [How To Use](#how-to-use)
<br>

## GKCell
A Subclass of `UIView` representing a cell in the canvas

### Initializers
``` swift
init?(coder: NSCoder)
```

```swift
init(
  frame: CGRect,
  row: Int,
  column: Int
)
```

```swift
init(
  row: Int,
  column: Int,
  frame: CGRect,
  cellColor: UIColor?,
  borderWidth: CGFloat?,
  borderColor: UIColor?,
  cornerRadius: CGFloat?
)
```

### Instance Properties
- **`var canAcceptDetach: Bool`** - Checks whether this cell can accepts more detaches of cell or not
  
- **`var canAcceptDrop: Bool`** - Check whether this cell can accept more drops or not
  
- **`var column: Int`** - Column at which cell is present in canvas
  
- **`var dragable: Bool`** - Flag which allow a cell to be able to be dragged in canvas, by `default set to false`
  
- **`var dropStorageCount: Int`** - Stores the maxmium number of cells currently droped on it
  
- **`var dropable: Bool`** - Flag which allow a cell to take another cell onto it or in other words to allow another cell to be droped into it, by `default set to false`
  
- **`var initialOrigin: CGPoint`** - Initial origin of cell in the canvas, updated as cell’s position changes
  
- **`var maxDropCapacity: Int`** - Stores the maximum capacity to accepts the drops on this view, `default is 1`
  
- **`var row: Int`** - Row at which cell is present in canvas

<br>

## GKSpec

A structure that defines the specifications of the canvas, including the maximum number of rows and columns required to make the canvas and the size taken by single cell in the canvas

### Initializers
```swift
init(
    rows: Int,
    columns: Int,
    cellSize: CGFloat,
    interCellInsets: CGFloat,
    cellColor: UIColor?,
    canvasColor: UIColor?,
    cellBorderWidth: CGFloat?,
    cellBorderColor: UIColor?,
    cellCornerRadius: CGFloat?,
    canvasCornerRadius: CGFloat?
)
```

### Instance Properties
- **`var canvasColor: UIColor?`** - Defines the background color of the canvas, `default is set to white`

- **`var canvasCornerRadius: CGFloat?`** - Defines the corner radius of canvas, `deafult is set to nil`

- **`var canvasHeight: CGFloat`** - Computes the total grid height based on the cell size and spacing between the cells.`

- **`var canvasWidth: CGFloat`** - Computes the total grid width based on the cell size and spacing between the cells.`

- **`var cellBorderColor: UIColor?`** - Defines the border color of the cell in canvas, `default is set to black`

- **`var cellBorderWidth: CGFloat?`** - Defines the border width of the cell in canvas, `default is set to nil`

- **`var cellColor: UIColor?`** - Defines the backgound color of the cell, `default is set to tertiarySystemGroupedBackground color`

- **`var cellCornerRadius: CGFloat?`** - Defines the corner radius of a cell in canvas, `default is set to nil`

- **`var cellSize: CGFloat`** - Defines the size of a single cell in a canvas

- **`var columns: Int`** - Defines Maximum number of columns in a canvas

- **`var interCellInsets: CGFloat`** - Defines the spacing between two cells in a canvas either horizontally or vertically, `default is set to 0`

- **`var rows: Int`** - Defines Maximun number of rows in a canvas

<br>

## GKCanvas

It is a manager to and handles cell interaction in [GKLayoutView](#gklayoutview). Each cell is assigned a unique `tag` i.e index of the cell in the canvas depending upon the row and column in which cell in placed

### Initializers
```swift
// Initializes the Canvas with a given canvas specifications.
init(spec: GKSpec)
```

### Instance Properties
- **`var gkCells: [IndexPath : GKCell]`** - Track all the cells to be displayed on the canvas with their positions

- **`var gklayout: UIView?`** - Superview which display the cells

- **`var gkspec: GKSpec`** - Specifications of the canvas


### Instance Methods

Add a marker at the corner of a cell in the canvas at given position, marker will be added even if cell not exists
```swift
public func addCornerMarker(
    at indexPath: IndexPath,
    size: CGSize = CGSize(width: 4, height: 4),
    offset: (dx: CGFloat, dy: CGFloat) = (dx: 2, dy: 2),
    cornerRadius: CGFloat = 2,
    backgroundColor: UIColor? = nil,
    borderWidth: CGFloat = 0,
    borderColor: UIColor? = .clear
)
```

Add markers at the corner of the cell in the canvas which satisfy certain condition on row and column, marker will be added even if cell not exists
```swift
func addCornerMarkers(where: ((_ row: Int, _ col: Int) -> Bool))
```

Attaches the layout view after initialization
```swift
func attachLayoutView(GKLayoutView)
```

Calculates the frame of a cell based on its position in the canvas
```swift
func computeCellFrame(
    row: Int,
    column: Int
) -> CGRect
```

Computes the cell origin based on its position in the canvas
```swift
func computeCellOrigin(
    row: Int,
    column: Int
) -> CGPoint
```

Fill the canvas with markers
```swift
func displayMarkers()
```

Erase all cells from the canvas.
```swift
func erase()
```

Returns all the cells present in the canvas
```swift
func getAllCells() -> [GKCell]
```

Returns all the positions of the cell in the canvas
```swift
func getAllIndexPaths() -> [IndexPath]
```

Returns the cell at given index if exists
```swift
func getCell(at: IndexPath?) -> GKCell?
```

Returns cell at a point if exists
```swift
func getCell(atPoint: CGPoint) -> GKCell?
```

Returns the cell from the canvas at given row and column if exists
```swift
func getCell(
    atRow: Int,
    column: Int
) -> GKCell?
```

Returns the size of single cell
```swift
func getCellSize() -> CGSize
```

Returns the index of cell at a point if exists
```swift
func getIndexPath(forCellAt: CGPoint) -> IndexPath?
```

Returns the index path of a cell in canvas if exists
```swift
func getIndexPath(ofCell: GKCell) -> IndexPath
```

Returns the size of canvas
```swift
func getSize() -> CGSize
```

Checks if a cell exists at a given position.
```swift
func hasCell(
    atRow: Int,
    column: Int
) -> Bool
```

Inserts a cell at a specific position
```swift
func insertCell(
    atRow: Int,
    column: Int
)
```

Refreshes the canvas layout
```swift
func layoutCanvasCells()
```

Fill the canvas with cells
```swift
func populate()
```

Fill the canvas with cells at given positions
```swift
func populateCells(at: [(row: Int, col: Int)])
```

Fill the canvas with cells which satisfy certain conditions on row and column
```swift
func populateCells(where: ((Int, Int) -> Bool))
```

Removes a cell from a specific position
```swift
func removeCell(
    atRow: Int,
    column: Int
)
```

Remove cells from given position
```swift
func removeCells(at: [(row: Int, col: Int)])
```

Remove cells which satisfy certain condition on row and column
```swift
func removeCells(where: ((Int, Int) -> Bool))
```

Removes a marker from the corner of the cell in the canvas at given position, marker will be added even if cell not exists
```swift
func removeCornerMarker(from: IndexPath)
```

Removes markers from the corner of the cells in the canvas which satisfy certain conditions on row and column, marker will be added even if cell not exists
```swift
func removeCornerMarker(where: ((_ row: Int, _ col: Int) -> Bool))
```

Removes all the markers from the canvas
```swift
func removeMarkers()
```

Updates cell properties at a given position
```swift
func updateCell(
    atRow: Int,
    column: Int, 
    update: ((inout GKCell) -> Void)?
)
```

Updates the cell position in canvas to new row or column
```swift
func updateCellPosition(
    withIndexPath: IndexPath,
    to: IndexPath
)
```

Update cells properties at given pair of positions (row, col)
```swift
func updateCells(
    at: [(row: Int, col: Int)],
    update: ((inout GKCell) -> Void)?
)
```

Update cells properties which satisfy certain condition on row and column
```swift
func updateCells(
    where: ((Int, Int) -> Bool),
    update: ((inout GKCell) -> Void)?
)
```

Update cells properties at given positions
```swift
func updateCells(
    with: [IndexPath],
    update: ((inout GKCell) -> Void)?
)
```

<br>

## GKLayoutView

A UIView subclass to display the cells in grid(2d-matrix) fashion, it uses [GKCanvas](#gkcanvas) to manage the cells

### Initializers
```swift
init?(coder: NSCoder)
```

```swift
init(
    frame: CGRect,
    spec: GKSpec,
    in: UIView,
    masksToBounds: Bool
)
```

```swift
init(
    spec: GKSpec,
    in: UIView,
    masksToBounds: Bool
)
```


### Instance Properties
- **`var allowCellDragNDrop: Bool`** - Flag which allow the cells in the canvas to be dragged in the canvas and dropped onto another cell

- **`var allowDropInEmptySpace: Bool`** - Flag which allow the cells in the canvas to be dropped in empty space

- **`var allowPathDrawing: Bool`** - Flag which allow canvas to make path between two cells when finger slides from one cell to another, tapping on the cell will not work after its activation instead you can update cell properties inside updateCellOnTrace or updateCellOnTraceEnd

- **`var canvas: GKCanvas`** - Canvas which manages the cells in the layout

- **`var columns: Int`** - Computes the number of row in the canvas

- **`var didTapCell: ((_ cell: GKCell) -> Void)?`** - Function to call when a cell gets tapped, allowPathDrawing should be set to false for its working Provide cell which gets tapped

- **`var initialDragOrigin: CGPoint`** - Stores origin of cell when it begans to drag

- **`var onCellDetach: ((GKCell, GKCell) -> Void)?`** - Function to call before detaching the cell from another cell Provides two parameters dragingCell and acceptorCell

- **`var onCellDropped: ((GKCell, GKCell) -> Void)?`** - Function to call before droping the cell into another cell Provides two parameters dragingCell and acceptorCell

- **`var pathLayers: [CAShapeLayer]`** - Track all the lines with the order in which they connect two cells, allowPathDrawing should be set to true for its working

- **`var pathLineWidth: CGFloat`** - Stores the width of the line connecting two cells

- **`var pathStrokeColor: UIColor?`** - Stores the stroke color of the line connecting two cells

- **`var rows: Int`** - Computes the number of rows in the canvas

- **`var selectedDragCell: GKCell?`** - Stores the cell which is currently under draging state

- **`var tracedCells: [IndexPath]`** - Track all the cells with the order in which they are connected, allowPathDrawing should be set to true for its working

- **`var updateCellOnTrace: ((GKCell, Set<UITouch>, UIEvent?) -> Void)?`** - Function to call when new cell gets connected, allowPathDrawing should be set to true for its working Provides three parameters cell, touch, event

- **`var updateCellOnTraceEnd: ((GKCell, Set<UITouch>, UIEvent?) -> Void)?`** - Function to call when event to connect two cells end to update cell properties, allowPathDrawing should be set to true for its working Provides three parameters cell, touch, event




### Instance Methods
Adds the subview in canvas at specific position and also add tag to them to identify them uniquely
```swift
func addSubview(
    atRow: Int,
    column: Int,
    view: UIView
)
```


Calls GKCanvs erase() method
```swift
func eraseCanvas()
```


Returns the height of canvas from starting row till ending row, if ending is not know use negative indexes to get last indexes
```swift
func getHeight(
    fromRow: Int,
    to: Int
) -> CGFloat
```


Returns the size of canvas from starting (row, col) till ending (row, col), if ending is not know use negative indexes to get last indexes
```swift
func getSize(
    fromGridAt: (row: Int, col: Int),
    to: (row: Int, col: Int)
) -> CGSize
```

Returns the width of canvas from starting column till ending column, if ending is not know use negative indexes to get last indexes
```swift
func getWidth(
    fromColumn: Int,
    to: Int
) -> CGFloat
```


Calls GKCanvas populate method
```swift
func populate()
```


Calls GKCanvas populateCells(where:) method
```swift
func populateCells(where: ((Int, Int) -> Bool))
```


Calls GKCanvas populateCells(at:) method
```swift
func populteCells(at: [(row: Int, col: Int)])
```


Calls GKCanvas removeCell(atRow:column) method
```swift
func removeCell(
    atRow: Int,
    column: Int
)
```


Calls GKCanvas removeCells(at:) method
```swift
func removeCells(at: [(row: Int, col: Int)])
```


Calls GKCanvas removeCells(where:) method
```swift
func removeCells(where: ((Int, Int) -> Bool))
```


Resizes the canvas size to new size
```swift
func resizeCanvas(to: CGSize)
```


Sets the size of subview with the size of canvas from starting (row, col) till ending (row, col), if ending is not know use negative indexes to get last indexes
```swift
func setSubviewSize(
    UIView,
    fromGridAt startCell: (row: Int, col: Int),
    to endCell: (row: Int, col: Int)
)
```

Calls GKCanvas updateCells(at:update:) method
```swift
func updateCells(
    at: (Int, Int),
    update: ((inout GKCell) -> Void)?
)
```

Calls GKCanvas updateCells(where:update) method
```swift
func updateCells(
    where: ((Int, Int) -> Bool),
    update: ((inout GKCell) -> Void)?
)
```


Calls GKCanvas updateCells(with:update) method
```swift
func updateCells(
    with: [IndexPath],
    update: ((inout GKCell) -> Void)?
)
```



Update the newly tracked cell properties at given position
```swift
func updateTracedCell(
    atIndexPath: IndexPath,
    update: ((GKCell) -> Void)?
)
```

<br>

## How To Use

To create the [GKLayoutView](#gklayoutview) first create the specifications for the canvas
```swift
import UIKit
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
```

<br>
Now as we've created the canvas specifications let's create `GKLayoutView` for our View Controller. By default canvas is placed at the center of superview

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  let gklayout = GKLayoutView(
      spec: gkspec,       // Canvas specifications
      in: view            // Superview in which gklayout gets displayed
  )
}
```

<br>
Now we've created our GKLayoutView we can place cells in it, to place cells in it call `populate()` method and RUN the app

```swift
gklayout.populate()
```

<br>
As you can see canvas gets filled with cells but what if you don't want all the cells, To get specific cells you can either use `populateCells` method or you can first fill the canvas then call `removeCells` method later on but it'll be time costly process as canvas first creates the cell and then removes the required cells so it is recommended to use `populateCells` for better performance

```swift
// gklayout.populate()
gklayout.populateCells(where: { (row, col) in
    return (col == 0 && row < 5) || (row == 7)
})
```
> Now RUN the app, you'll see only the required cells are drawn which satisfy the condition

<br>
To update the cell on specific positions use `updateCells` method

```swift
gklayout.updateCells(where: { (row, col) in
    return (col == 0 && row < 5)
}, update: { cell in
    cell.backgroundColor = .systemOrange
})
```

<br>
To check how your canvas grid is looking you can add markers in your canvas by calling `displayMarkers()` method

```swift
gklayout.canvas.displayMarkers()
```

<br>
To add a subview in the canvas at specific position in grid you can use `addSubview(atRow:column:view)` method

```swift
let label = UILabel()
label.text = "Hello"
label.textAlignment = .center
label.layer.borderColor = UIColor.systemOrange.cgColor
label.layer.borderWidth = 1

// setting the size of label
gklayout.setSubviewSize(label, fromGridAt: (row: 0, col: 1), to: (row: 0, col: -2))

// adding label in canvas at row 1, column 2
gklayout.addSubview(atRow: 1, column: 2, view: label)

// Now as you've added the label in the canvas try printing tag of label
// You'll notice that a number is printed so that number denotes the index of that label where it is located
// If you add another view at same row and column then that view also get's same tag
// Tag is calculated by Row-Order Indexing
// tagValue = (currentRow * totalNumberOfColumns) + currentColumn
```

<br>
What if you want to add a subview in a specific cell? Here is how you can achieve that

```swift
let label = UILabel()
label.text = "Hello"
label.textAlignment = .center

if let cell = self.gklayout.canvas.getCell(atRow: self.gkspec.rows-1, column: 0) {
    label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    
    // You'll have to manually set the size of the label using 'bounds' property
    label.bounds.size = CGSize(width: cell.bounds.width-10, height: cell.bounds.height-10)
    
    // Setting the center of the label to the cell's center using 'bounds' property
    // Using 'bounds' here because if we use cell's center it'll calculate from its parent's coordinate environment
    label.center = CGPoint(x: cell.bounds.width/2, y: cell.bounds.height/2)
    
    cell.addSubview(label)
    
    // Now try printing the 'tag' value of label
    // You'll get the same tag value as the cell's tag value
}
```
> Note: If you want to set the size prefer use 'bounds' property and for the position prefer 'frame' property because 'bounds' take coordination system of its own environment while 'frame' takes coordinate system of its parent environment

<br>
Easy Right!
Now lets do something interesting, lets activate the drag and drop features in the cells

```swift
// Activate the drag and drop
gklayout.allowCellDragNDrop = true

// Now as you activated the features tell the canvas which cells are dragable and which are dropable
// Lets update our cell creation code
gklayout.updateCells(where: { (row, col) in
    return (col == 0 && row < 5) || (row == 7)
}, update: { cell in
    if cell.row == 7 { cell.dragable = true }    // Enable all the cells to be able to draged on row 7
    else {                                       // Enable all the cells to be able to accept the drop where (col == 0 and row < 5)
        cell.backgroundColor = .systemOrange
        cell.dropable = true
    }
})
```
> Now RUN the app and see you can drag and drop the cells

<br>
To run specific task while droping the cell or detaching the cell you can set the properties `onCellDropped` and `onCellDetach`

```swift
gklayout.onCellDropped = { (cell: GKCell, targetCell: GKCell) in
    cell.bounds.size.width -= 10
    cell.bounds.size.height -= 10
    cell.backgroundColor = UIColor(cgColor: targetCell.layer.borderColor!)
    targetCell.backgroundColor = .white
}

gklayout.onCellDetach = { (cell: GKCell, targetCell: GKCell) in
    cell.bounds.size = self.gklayout.canvas.getCellSize()
    targetCell.backgroundColor = cell.backgroundColor
    cell.backgroundColor = .white
}
```
> Now RUN the app and you'll be seeing a smooth animation while draging or droping the cells

<br>
But still you may have found that you are not able to drop the cell in the empty space. To drop it in empty space activate `allowDropInEmptySpace`

```swift
gklayout.allowDropInEmptySpace = true
```
> Now you can drop the cells in empty space too

<br>
What if you want to connect two cells with a line as you move your fingers from one cell to another?
You can achieve this too by activating `allowPathDrawing`

```swift
gklayout.allowPathDrawing = true
```
> RUN the app and see you can now getting the track of cells in which you are touching them
> NOTE: If allowPathDrawing is active, Drag and drop features will gets deactivated as you're already keeping track of you path

<br>
You can update the cell while connecting the cells, to do this use `updateCellOnTrace` and `updateCellOnTraceEnd`

```swift
gklayout.pathStrokeColor = .systemOrange
gklayout.updateCellOnTrace = { (cell, touch, event) in
    cell.backgroundColor = self.gklayout.pathStrokeColor?.withAlphaComponent(0.5)
}

gklayout.updateCellOnTraceEnd = { (cell, touch, event) in
    cell.backgroundColor = self.gklayout.canvas.gkspec.cellColor
}
```

<br>
If you want to update the cell or perform certain action while clicking the cell you can set `didTapCell` handler to perform custom tasks. For this you'll have to first disable the `allowPathDrawing` property and also the drag and drop property

```swift
// gklayout.allowPathDrawing = true
// gklayout.allowCellDragNDrop = true
// gklayout.allowDragInEmptySpace = true

gklayout.didTapCell = { cell in
    print("Cell tapped at row: \(cell.row) and column: \(cell.column)")
    
    UIView.animate(withDuration: 0.5) {
        cell.backgroundColor = .systemOrange.withAlphaComponent(0.5)
    } completion: { _ in
        UIView.animate(withDuration: 0.5) {
            cell.backgroundColor = self.gklayout.canvas.gkspec.cellColor
        }
    }
}
```

<br>

## Demo GIFs
<p align="center">
  <img src="https://github.com/Devansh-Seth-DEV/GridKit-DevSource/blob/main/GridKit/GridKit.docc/Resources/gkcelltap.gif?raw=true" width="30%">
  <img src="https://github.com/Devansh-Seth-DEV/GridKit-DevSource/blob/main/GridKit/GridKit.docc/Resources/gkpathdrawing.gif?raw=true" width="30%">
  <img src="https://github.com/Devansh-Seth-DEV/GridKit-DevSource/blob/main/GridKit/GridKit.docc/Resources/gkdragndrop.gif?raw=true" width="30%">
</p>

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
