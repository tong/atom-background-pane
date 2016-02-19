
import js.Browser.document;
import js.html.DivElement;
import Atom.workspace;
import BackgroundPane;

class BackgroundPaneView {

    public var provider : ContentProvider;

    var element : DivElement;
    var attached : Bool;
    var disposables : atom.CompositeDisposable;

    public function new() {

        element = document.createDivElement();
        element.classList.add( 'background-pane' );

        attached = false;

        disposables = new atom.CompositeDisposable();
        disposables.add( workspace.onDidAddPane( updateVisibility ) );
        disposables.add( workspace.onDidDestroyPane( updateVisibility ) );
        disposables.add( workspace.onDidChangeActivePaneItem( updateVisibility ) );

        haxe.Timer.delay( function() {
            if( shouldBeAttached() ) {
                attach();
                updateContent();
            }
        }, 1000 );
    }

    public function destroy() {
        disposables.dispose();
    }

    function attach() {
        if( !attached ) {
            Atom.views.getView( workspace.getActivePane() ).appendChild( element );
            attached = true;
        }
    }

    function detach() {
        if( attached ) {
            element.remove();
            attached = false;
        }
    }


    function updateVisibility(_) {
        if( provider == null ) {
            detach();
            return;
        }
        var shouldAttach = shouldBeAttached();
        if( attached ) {
            if( !shouldAttach ) detach();
        } else {
            if( shouldAttach ) attach();
        }
        if( attached ) updateContent();
    }

    inline function updateContent() {
        if( provider != null ) element.innerHTML = provider.get();
    }

    static function shouldBeAttached() : Bool {
        return workspace.getPanes().length == 1 && workspace.getActivePaneItem() == null;
    }
}
