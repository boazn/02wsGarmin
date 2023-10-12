import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
var page = 1;
class JwsView extends WatchUi.View {
    hidden var mMessage = "02WS\nPress menu or\nselect button";
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
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
         System.println("JwsView onShow:");         
        
        
    }

     function onLoad() {
          System.println("JwsView onLoad:");
    }

    // Update the view
    function onUpdate(dc) {
    
        var DateLabel = View.findDrawableById("DateLabel") as Text;
        var TempLabel = View.findDrawableById("TempLabel") as Text;
        var WindHumLabel = View.findDrawableById("WindHumLabel") as Text;
        var sigweatherText = View.findDrawableById("sigweatherText") as Text;
        var RainText = View.findDrawableById("RainLabel") as Text;
        DateLabel.setText(mDate);
        TempLabel.setText(mTempTitle);
        WindHumLabel.setText(mWindHumTitle);
        sigweatherText.setText(mSigWeather);
        RainText.setText(mRain);
        if (mlang == 0){
            changeBitmap(dc);
        }
        System.println("JwsView OnUpdate:" + mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
        View.onUpdate( dc );
         
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function onReceive(args) {
        
        if (args instanceof Dictionary) {
            var Mountain = [
                :Mountain0,
                :Mountain1
            ];
           var Mountain_str = loadResource(Rez.Strings[Mountain[mlang]]);
           var Valley = [
                :Valley0,
                :Valley1
            ];
           var Valley_str = loadResource(Rez.Strings[Valley[mlang]]);
            var mCurrent = args.get("current") as Dictionary;
            mDate = getDisplayString(mCurrent.get("date"+mlang)) + "";
            if (mCurrent.get("islight").equals("1")){
                mTempTitle = getDisplayString(mCurrent.get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " " + Mountain_str + " \n " + getDisplayString(mCurrent.get("temp2") + StringUtil.utf8ArrayToString([0xC2,0xB0])) + " " + Valley_str;
            }
            else{
                mTempTitle = getDisplayString(mCurrent.get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " " + Mountain_str + " \n " + getDisplayString(mCurrent.get("temp3") + StringUtil.utf8ArrayToString([0xC2,0xB0])) + " " + Valley_str;
            }
            var sigRunWalk =  args.get("sigRunWalkweather") as Dictionary;   
            mSigWeather = getSigWeatherDisplayString(sigRunWalk, mlang);
            if (!mCurrent.get("rainchance").equals("0")){
                var rainchance = [
                :rainchance0,
                :rainchance1
            ];
           var rainchance_str = loadResource(Rez.Strings[rainchance[mlang]]);
              mRain = mCurrent.get("rainchance") + "% " + rainchance_str;
            }
            
        }
        else if (args instanceof Array){
            mMessage = "is Array";
        }
        else if (args instanceof Lang.String) {
             mDate = args;
        }
        System.println("JwsView onReceive:"+ mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
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
        var bitmap = findDrawableById("logoc") as Bitmap;
        bitmap.setBitmap(Rez.Drawables.logoc_eng);
         View.onUpdate( dc );
    }

    //Get a display string for an array
    function getSigWeatherDisplayString(array as Dictionary, lang) {
        var displayString = "";
        for(var index = 1; index < array.size(); index++) {
            if (index == 1){
                mWindHumTitle = getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            else {
                displayString += " \n" + getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            if(index < (array.size()-1)) {
                displayString += "";
            }
           displayString += "";
        }
        return displayString;
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
    function getSigWeatherDictionaryDisplayString(dictionary as Dictionary, lang) {
        var displayString = "";
        displayString += dictionary["sigtitle"+lang];
     
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