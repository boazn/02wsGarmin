import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
(:glance)
class JwsGlanceView extends WatchUi.GlanceView {
      hidden var mMessage = "02WS\n";
    hidden var mDate = "";
    hidden var mSigWeather = "";
    hidden var mTempTitle = "";
    hidden var mTemp = null;
    hidden var mWindHumTitle = "";
    hidden var mRain = "";
    hidden var mModel;
    var mLogo;
    var mlang;
    var mwriter;
    hidden var jTextArea;

    
    function initialize(lang) {
        WatchUi.GlanceView.initialize();
        mlang = lang;
        System.println("GlanceView initialize:" + mlang); 
            
    }
     // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GlanceLayout(dc));
    }
    // Restore the state of the app and prepare the view to be shown
    function onShow() {
         System.println("GlanceView onShow:");         
          
    }

     function onLoad() {
          System.println("GlanceView onLoad:");
    }

    // Update the view 
    function onUpdate(dc as Dc) {
         System.println("GlanceView onUpdate:" + mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);

        var _message = mTempTitle + "\n" + mWindHumTitle + "\n" + mRain;
        var glanceLabel = View.findDrawableById("sigweatherTextDetailsGlance") as Text;
        glanceLabel.setText(_message);
        glanceLabel.setBackgroundColor(getBGColor());
        glanceLabel.setColor(getColor());
        System.println("GlanceView drawText:" + _message);
        
        View.onUpdate( dc );

        
    }

    function getColor() {
        if (mTemp == null)
           {return Graphics.COLOR_WHITE;}
        if (mTemp >= 0 and mTemp < 5)
            {return Graphics.COLOR_WHITE;}
         if (mTemp >= 5 and mTemp < 10)
            {return Graphics.COLOR_WHITE;}
         if (mTemp >= 10 and mTemp < 15)
            {return Graphics.COLOR_WHITE;}
         if (mTemp >= 15 and mTemp < 20)
            {return Graphics.COLOR_BLACK;}
         if (mTemp >= 20 and mTemp < 25)
            {return Graphics.COLOR_BLACK;}
         if (mTemp >= 25 and mTemp < 30)
            {return Graphics.COLOR_BLACK;}
         if (mTemp >= 30 and mTemp < 35)
            {return Graphics.COLOR_BLACK;}
         if (mTemp >= 35 and mTemp < 50)
            {return Graphics.COLOR_WHITE;}
         return Graphics.COLOR_WHITE;
    }

    function getBGColor() {
        if (mTemp == null)
           {return Graphics.COLOR_BLACK;}
        if (mTemp >= 0 and mTemp < 5)
            {return Graphics.COLOR_PURPLE;}
         if (mTemp >= 5 and mTemp < 10)
            {return Graphics.COLOR_DK_BLUE;}
         if (mTemp >= 10 and mTemp < 15)
            {return Graphics.COLOR_DK_GREEN;}
         if (mTemp >= 15 and mTemp < 20)
            {return Graphics.COLOR_GREEN;}
         if (mTemp >= 20 and mTemp < 25)
            {return Graphics.COLOR_ORANGE;}
         if (mTemp >= 25 and mTemp < 30)
            {return Graphics.COLOR_PINK;}
         if (mTemp >= 30 and mTemp < 35)
            {return Graphics.COLOR_RED;}
         if (mTemp >= 35 and mTemp < 50)
            {return Graphics.COLOR_DK_RED;}
         return Graphics.COLOR_BLACK;
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

     
    public function onReceive(args as Dictionary) {
        if (args instanceof Dictionary) {
            var mCurrent = args.get("current") as Dictionary;
            mDate = getDisplayString(mCurrent.get("daytime" + mlang)) + "";
            var mTempstr = mCurrent.get("temp") as String;
            mTemp = mTempstr.toFloat();
            if (mCurrent.get("islight").equals("1")){
                mTempTitle = getDisplayString(mCurrent.get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]);
            }
            else{
                mTempTitle = getDisplayString(mCurrent.get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]);
            }
            var sigRunWalk = args["sigRunWalkweather"] as Dictionary;    
            mSigWeather = getSigWeatherDisplayString(sigRunWalk, mlang);
            if (!mCurrent.get("rainchance").equals("0")){
                var rainchance = [
                :rainchance0,
                :rainchance1
            ];
                var rainchance_str = loadResource(Rez.Strings[rainchance[mlang]]);
              mRain = mCurrent.get("rainchance") + "% " + rainchance_str ;
            }
            
        }
        else if (args instanceof Array){
            mMessage = "is Array";
        }
        else if (args instanceof Lang.String) {
             mTempTitle = args;
        }
        System.println("GlanceView onReceive:"+ mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
        WatchUi.requestUpdate();
    }

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
  

    function changeBitmap() {
        var bitmap = findDrawableById("logoc") as Bitmap;
        bitmap.setBitmap(Rez.Drawables.logoc_eng);
        // View.onUpdate( dc );
    }

    //Get a display string for an array
    function getSigWeatherDisplayString(array as Dictionary, lang) {
        var displayString = "";
        for(var index = 1; index < array.size(); index++) {
            if (index == 1){
                var con = array[index] as Dictionary;
                mWindHumTitle = con["sigtitle"+lang];
            }
            else {
                
              displayString  += getSigWeatherDictionaryDisplayString(array[index], lang);
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
        displayString += dictionary["sigtitle"+lang] + " \n" +  dictionary["sigext"+lang];
     
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