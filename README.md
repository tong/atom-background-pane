
# Background Pane Package

Allows other packages to set the background content when there are no open editors.

To change content a package must provide:

1.  A `atom.background-pane` service .
```coffee
"providedServices": {
    "atom.background-pane": {
        "description": "Provides content for empty background panes",
        "versions": {
            "1.0.0": "provideBackgroundPaneContent"
        }
    }
}
```

2. A method returning a type of:
```haxe
typedef ContentProvider = { get : Void->String }
```
For example:
```haxe
static function provideBackgroundPaneContent() {
    return {
        get: function() {
            return '!FTW';
        }
    };
}
```
