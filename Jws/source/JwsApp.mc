import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class JwsApp extends Application.AppBase {
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
         var lang = Application.getApp().getProperty("lang");
        System.println("lang=" + lang);
        mView = new JwsView(lang);
        return [mView, new JwsDelegate(mView.method(:onReceive))] as Array<Views or InputDelegates>;
       // return [ new JwsView() ] as Array<Views or InputDelegates>;
    }
    (:glance)
    function getGlanceView() {
        var lang = Application.getApp().getProperty("lang");
        var view = new JwsGlanceView(lang);
        var delegate = new JwsDelegate(view.method(:onReceive));
        return [ view ];
    }

}

function getApp() as JwsApp {
    return Application.getApp() as JwsApp;
}