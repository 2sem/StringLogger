# StringLogger

[![CI Status](https://img.shields.io/travis/2sem/StringLogger.svg?style=flat)](https://travis-ci.org/2sem/StringLogger)
[![Version](https://img.shields.io/cocoapods/v/StringLogger.svg?style=flat)](https://cocoapods.org/pods/StringLogger)
[![License](https://img.shields.io/cocoapods/l/StringLogger.svg?style=flat)](https://cocoapods.org/pods/StringLogger)
[![Platform](https://img.shields.io/cocoapods/p/StringLogger.svg?style=flat)](https://cocoapods.org/pods/StringLogger)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

StringLogger is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StringLogger'
```

## Usages

### Initialize

#### Change Current Log Level

```swift
String.Logger.console.level = .info;
```

#### Format Date Time

```swift
String.Logger.console.dateFormat = "HH:mm:ss.SSS";
```

#### Log Level Icon

```swift
String.Logger.console.icons[.fatal] = "💥";
```

### Logging

```swift
"call".debug();
//== "call".debug(option: [.default]);
//== "call".debug(option: [.date, .file, .line, .function]);
```

```swift
"call".debug(option: [.file, .line]);
```

### Custom Logger

```swift
class MyLogger : String.Logger{
    override init() {
        super.init();
        
        self.level = .debug;
    }
    
    override func log(msg: String, level: String.Logger.LogLevel, option: String.Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line) {
        print("MY LV\(level.rawValue) \(FUNCTION) \(msg)");
    }
}
```

```swift
MyLogger().register();
```

### Output
![Screenshot](/Example/Screenshots/1.png)
Format: ![Alt Text](url)

## Author

leesam, kofggm@gmail.com

## License

StringLogger is available under the MIT license. See the LICENSE file for more info.
