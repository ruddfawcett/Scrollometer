# Scrollometer

Scrollometer is a simple way to track how far users are scrolling in a `UIScrollView` or sublcass (`UITableView`, `UICollectionView`, etc).

## Usage

```swift
Scrollometer.track(self.tableView) { totalDistanceTravelledX, totalDistanceTravelledY in
    print(String(format: "%.2f", totalDistanceTravelledY))
}
```

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Scrollometer as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ruddfawcett/Scrollometer.git", .upToNextMajor(from: "1.0"))
]
```

## Todo

- [ ] Support ability to convert points into real world units of measurement.

## Credits

Scrollometer was created by [Rudd Fawcett](http://ruddfawcett.com). You can find him on Twitter at [@ruddfawcett](https://twitter.com/ruddfawcett).

## License

Scrollometer is released under the MIT license. [See LICENSE](https://github.com/ruddfawcett/Scrollometer/blob/main/LICENSE) for details.
