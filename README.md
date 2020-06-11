# @NullCodable

`@NullCodable` is a property wrapper that encodes `nil` optional values as `null` when encoded using `JSONEncoder`. 

On its own, `JSONEncoder` will omit optional properties that are `nil` - meaning that this:
```swift
struct Test: Codable {
  var name: String? = nil
}
```
will be encoded as: `{}`.

If for some reason, you would like optional properties that are nil
to be encoded in JSON as `null`, then marking those properties as `@NullCodable`
will do so.

For example, adding `@NullCodable` like this:
```swift
  struct Test: Codable {
    @NullCodable var name: String? = nil
  }
```
will encode as: `{\"name\": null}`.
