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

### Removing calendar events

```swift

EventDB.removeEvents(Month(year: 2015, month: 1))

EventDB.removeEvents(Month(year: 2015, month: 1), day: 1)

// remove events from 1/5/2015 to 1/19/2015
EventDB.removeEvents(Month(year: 2015, month: 1), day: 5, length: 15)
```


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

TTEventKit is released under the MIT license. See LICENSE for details.
