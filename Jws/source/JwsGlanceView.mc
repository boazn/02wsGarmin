import Toybox.Graphics;
import Toybox.WatchUi;
(:glance)
class JwsGlanceView extends WatchUi.GlanceView {
      hidden var mMessage = "02WS\n";
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
        WatchUi.GlanceView.initialize();
        mlang = lang;
        
            
    }
   
    // Restore the state of the app and prepare the view to be shown
    function onShow() {
         System.println("GlanceView onShow:");         
          
    }

     function onLoad() {
          System.println("GlanceView onLoad:");
    }

    // Update the view
    function onUpdate(dc) {
      
         System.println("GlanceView OnUpdate:" + mDate + " " + mTempTitle + " " + mWindHumTitle + " " + mSigWeather);
          var DateLabel = View.findDrawableById("DateLabel");
        var TempLabel = View.findDrawableById("TempLabel");
        var WindHumLabel = View.findDrawableById("WindHumLabel");
        var sigweatherText = View.findDrawableById("sigweatherText");
        var RainText = View.findDrawableById("RainLabel");
        //DateLabel.setText(mDate);
        //TempLabel.setText(mTempTitle);
        //WindHumLabel.setText(mWindHumTitle);
        //sigweatherText.setText(mSigWeather);
        //RainText.setText(mRain);
        var _message = mDate + "\n" + mTempTitle + "\n" + mWindHumTitle;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        System.println("GlanceView drawText:" + _message);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_TINY, _message, Graphics.TEXT_JUSTIFY_CENTER);
        View.onUpdate( dc );
        jTextArea = new WatchUi.Text({:text=>_message,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_TINY,
            :x=>"center",
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_HALIGN_CENTER});
            jTextArea.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
        jTextArea.draw(dc);
        //View.onUpdate( dc );

        
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

     
    public function onReceive(args) {
        if (args instanceof Dictionary) {
            mDate = getDisplayString(args.get("current").get("daytime" + mlang)) + "";
            if (args.get("current").get("islight").equals("1")){
                mTempTitle = getDisplayString(args.get("current").get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " - " + getDisplayString(args.get("current").get("temp2") + StringUtil.utf8ArrayToString([0xC2,0xB0]));
            }
            else{
                mTempTitle = getDisplayString(args.get("current").get("temp")) + StringUtil.utf8ArrayToString([0xC2,0xB0]) + " - " + getDisplayString(args.get("current").get("temp3") + StringUtil.utf8ArrayToString([0xC2,0xB0]));
            }
                
            mSigWeather = getSigWeatherDisplayString(args.get("sigRunWalkweather"), mlang);
            if (!args.get("current").get("rainchance").equals("0")){
              mRain = args.get("current").get("rainchance") + "% " + loadResource(Rez.Strings.rain);
            }
            
        }
        else if (args instanceof Array){
            mMessage = "is Array";
        }
        else if (args instanceof Lang.String) {
             mDate = args;
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
        var bitmap = findDrawableById("logoc");
        bitmap.setBitmap(Rez.Drawables.logoc_eng);
         View.onUpdate( dc );
    }

    //Get a display string for an array
    function getSigWeatherDisplayString(array, lang) {
        var displayString = "";
        for(var index = 1; index < array.size(); index++) {
            if (index == 1){
                mWindHumTitle = getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            else {
                
                 += getSigWeatherDictionaryDisplayString(array[index], lang);
            }
            if(index < (array.size()-1)) {
                displayString += "";
            }
           displayString += "";
        }
        return displayString;
    }

    //Get a display string for an array
    function getArrayDisplayString(array) {
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
    function getSigWeatherDictionaryDisplayString(dictionary, lang) {
        var displayString = "";
        displayString += dictionary["sigtitle"+lang] + " \n" +  dictionary["sigext"+lang];
     
        return displayString;
    }

    //Get a display string for a dictionary
    function getDictionaryDisplayString(dictionary) {
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