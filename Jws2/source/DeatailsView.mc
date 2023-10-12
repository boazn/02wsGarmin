import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
class DetailsView extends WatchUi.View {
    hidden var mMessage = "Press menu button";
    hidden var mDate = "";
    hidden var mSigWeather = "";
    hidden var mTempTitle = "";
    hidden var mWindHumTitle = "";
    hidden var mRain = "";
    hidden var mModel;
    var mLogo;
    var mlang;
    var mwriter;
    hidden var jTextArea;

    function initialize(lang) {
        WatchUi.View.initialize();
        mlang = lang;
        
            
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("DetailsView onLayout:");
        setLayout( Rez.Layouts.DetailsLayout( dc ) );
        
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
        System.println("DetailsView onShow:");            
        
        
    }

     function onLoad() {
        System.println("DetailsView onLoad:");           
    }

    // Update the view
    function onUpdate(dc as Dc) {
        System.println("DetailsView onUpdate:");
        var sigweatherText = View.findDrawableById("sigweatherTextDetails") as Text;
        var myStats = System.getSystemStats();
        var jwsjson = "";
           if ((Toybox.Application has :Storage)&&(myStats.freeMemory > 14000)){
                jwsjson = Storage.getValue("02wsjson") as Dictionary;
            }
            else{
                jwsjson = Application.Properties.getValue("02wsjson") as Dictionary;
            }
        // System.println(jwsjson);
        var sigRunWalk = jwsjson["sigRunWalkweather"] as Dictionary;
        var mSigWeather = getSigWeatherDisplayString(sigRunWalk, mlang);
        sigweatherText.setText(mSigWeather);
        
        if (mlang == 0){
            changeBitmap(dc);
        }
        View.onUpdate( dc );
         
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function getSigWeatherDisplayString(array as Dictionary, lang as Number) {
            var displayString = "";
            for(var index = 1; index < array.size(); index++) {
                    displayString += getSigWeatherDictionaryDisplayString(array[index] as Dictionary, lang);
                    displayString += "   ";
            }
            System.println(displayString);
            return displayString;
    }
             //Get a display string for a dictionary
    function getSigWeatherDictionaryDisplayString(dictionary as Dictionary, lang) {
        var displayString = Lang.format("$1$ \n $2$", [dictionary["sigtitle"+lang], dictionary["sigext"+lang]]);
        if (displayString.length() > 20){
            displayString = Lang.format("$1$ \n $2$", [dictionary["sigtitle"+lang], dictionary["sigext"+lang]]);
        }
            
     
        return displayString;
    }
    function onReceive(args) {
        System.println("DetailsView onReceive:"+args);
    
        WatchUi.requestUpdate();
    }

      //Get a displayable string for the current object
    function getDisplayString(item) {
        var displayString = "";
        if(item instanceof Toybox.Lang.Array) {
            displayString = getArrayDisplayString(item);
        } else if(item instanceof Toybox.Lang.Dictionary) {
            displayString = getDictionaryDisplayString(item);
        } else {
            //displayString = "Simple Value\n";
            displayString = item.toString();
        }

        return displayString;
    }

    function changeBitmap(dc) {
        var myStats = System.getSystemStats();
        if (myStats.freeMemory < 20000)
        { return; }
        var bitmap = View.findDrawableById("logoDetailsLayout") as Bitmap;
        var image = Application.loadResource( Rez.Drawables.logoc_eng ) as BitmapResource;
        bitmap.setBitmap(image);
         View.onUpdate(dc);
    }

   

    //Get a display string for an array
    function getArrayDisplayString(array as Array) {
         var displayString = "";
        displayString += "[\n";
        for(var index = 0; index < array.size(); index++) {

            displayString += array[index].toString();

            if(index < (array.size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "]\n";

        return displayString;
    }

    //Get a display string for a dictionary
    function getDictionaryDisplayString(dictionary as Dictionary) {
        var displayString = "\n";
        displayString += "{";
        for(var index = 0; index < dictionary.keys().size(); index++) {
            var key = dictionary.keys()[index];
            var value = dictionary[key];

            displayString += key + "=>" + value.toString();

            if(index < (dictionary.keys().size()-1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "}";

        return displayString;
    }
}
