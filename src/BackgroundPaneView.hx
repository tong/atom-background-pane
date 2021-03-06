
import BackgroundPane;
import Atom.workspace;
import js.Browser.document;
import js.html.DivElement;

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
            element.innerHTML = '';
            attached = false;
        }
    }

    function updateVisibility(_) {
        var activePaneItem = workspace.getActivePane();
        if( provider == null || activePaneItem == null ) {
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
        if( provider != null ) {
            /*
            var e = provider.get();
            if( e != null ) {
                element.appendChild( provider.get() );
            }
            */
            var html = provider.get();
            if( html != null ) {
                element.innerHTML = html;
            } else {
                element.innerHTML = '';
            }
        }
    }

    inline function shouldBeAttached() : Bool {
        return workspace.getActivePaneItem() == null;
        //return workspace.getPanes().length == 1 && workspace.getActivePaneItem() == null;
    }
}
