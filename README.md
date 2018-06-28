# CodableKit

[![Build Status](https://travis-ci.org/kylinroc/CodableKit.svg?branch=master)](https://travis-ci.org/kylinroc/CodableKit)

## Usage

### Shorthands

Sometimes we have to write `init(from:)` by hand, so let's make this work a little bit easier:

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // self.name = try container.decode(String.self, forKey: .name)
    // Shorthand:
    self.name = try container.decode(.name)
    
    // self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    // Shorthand:
    self.nickname = try container.decodeIfPresent(.nickname)
    
    // self.title = try? container.decode(String.self, forKey: .title)
    // Shorthand:
    self.title = container[.title]
}
```

### AnyCodingKey

When writing `init(from:)` by hand, we also have to write the annoying `CodingKeys`. So let's introducing `AnyCodingKey`, and forget about `CodingKeys`:

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container() // decoder.container(keyedBy: AnyCodingKey.self)
    
    self.name = try container.decode("name")
    self.nickname = try container.decoderIfPresent("nickname")
    self.title = container["title"]

    // Some tricks:
    self.camelCasePropertyWithDefaultValue 
        = container["camel_case_property_with_default_value"] ?? 42
}
```

### JSON

## Integration
