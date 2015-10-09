# TTEventKit

A convenient event kit written by Swift 2.0.

<a target="_blank" href="https://raw.githubusercontent.com/tattn/TTEventKit/assets/calendar_anime.gif">
<img width="30%" height="30%" alt="Calendar" src="https://raw.githubusercontent.com/tattn/TTEventKit/assets/calendar_anime.gif"></a>

[Calendar](https://raw.githubusercontent.com/tattn/TTEventKit/assets/calendar.png)

## Installation

Using TTEventKit in your project requires the following steps:

In your top-level project directory, enter this:
```bash
git submodule add https://github.com/tattn/TTEventKit.git
```
2. Open the `TTEventKit` folder, and drag `TTEventKit.xcodeproj` into the project navigator of your project.
3. Select the project file from the project navigator, and select the target for where you want to add frameworks.
4. Select the "Build Phases" tab, and add `TTEventKit.framework` to "Link Binary With Libraries".
5. Click on the "+" button at the top left of the panel and select "New Copy Files Phase".
6. Open the "Copy Files", and set the "Destination" to "Frameworks", and add `TTEventKit.framework`.

## Usage

### Getting permission to access calendar events

```swift
import TTEventKit

EventStore.requestAccess() { (granted, error) in
    if granted {
        println("got permission")
    }
}
```

### Getting calendar events

```swift
let events = EventStore.getEvents(Month(year: 2015, month: 1))

if events != nil {
    for e in events {
        println("Title \(e.title)")
        println("startDate: \(e.startDate)")
        println("endDate: \(e.endDate)")
    }
}
```

### Adding calendar events

```swift
let start = NSDate()
let end = NSDate(timeIntervalSinceNow: 60*60)
EventStore.addEvent("new event", notes: "This is a test", startDate: start, endDate: end)
```

### Removing calendar events

```swift

EventStore.removeEvents(year: 2016, month: 1)

EventStore.removeEvents(year: 2016, month: 1, day: 1)

// remove events from 1/5/2016 to 1/19/2016
EventStore.removeEvents(year: 2016, month: 1, day: 5, length: 15)
```

### Showing the view to edit an event

```swift
// simple
EventUI.showEditView()

// preset
let event = EventStore.create()
event.title = "new event"
event.notes = "memo"
EventUI.showEditView(event)

// update
let month = Month(year: 2016, month: 10)
let event2 = EventStore.getEvents(month, day: 1)[0]
EventUI.showEditView(event2)
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

TTEventKit is released under the MIT license. See LICENSE for details.
