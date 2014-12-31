# TTEventKit

## Installation


## Usage

### Getting permission to access calendar events

```swift
import TTEventKit

EventDB.requestAccess() { (granted) in
    if granted {
        println("got permission")
    }
}
```

### Getting calendar events

```swift
let events = EventDB.getEvents(Month(year: 2015, month: 1))

if events  != nil {
    for e in events {
        println("Title \(e.title)")
        println("startDate: \(e.startDate)")
        println("endDate: \(e.endDate)")
    }
}
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

TTEventKit is released under the MIT license. See LICENSE for details.
