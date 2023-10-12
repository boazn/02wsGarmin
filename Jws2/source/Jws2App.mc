import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class Jws2App extends Application.AppBase {

    hidden var mView;
    hidden var gView;
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
         var lang = Application.Properties.getValue("lang");
        System.println("lang=" + lang);
        mView = new JwsView(lang);
        return [mView, new JwsDelegate(mView.method(:onReceive))] as Array<Views or InputDelegates>;
       // return [ new Jws2View() ] as Array<Views or InputDelegates>;
    }
    (:glance)
    function getGlanceView()  {
        var lang = Application.Properties.getValue("lang");
        var view = new JwsGlanceView(lang);
        var delegate = new JwsDelegate(view.method(:onReceive));
        return [ view];
    }

}

function getApp() as Jws2App {
    return Application.getApp() as Jws2App;
}