
typedef ContentProvider = {
    get : Void->Dynamic
}

@:keep
@:expose
class BackgroundPane {

    static inline function __init__() untyped module.exports = BackgroundPane;

    static var view : BackgroundPaneView;
    static var provider : ContentProvider;

    static function activate( savedState ) {
        trace( 'Atom-background-pane' );
        view = new BackgroundPaneView();
    }

    static function deactivate() {
        view.destroy();
    }

    static function consumeContentProvider( provider : ContentProvider ) {
        view.provider = provider;
    }
}
