//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Storage;
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
    function onUpdate(dc) {
        System.println("DetailsView onUpdate:");
        var sigweatherText = View.findDrawableById("sigweatherTextDetailes");
        var jwsjson = "";
           if (Toybox.Application has :Storage){
                jwsjson = Storage.getValue("02wsjson");
            }
            else{
                jwsjson = Application.getApp().getProperty("02wsjson");
            }
        // System.println(jwsjson);
        var mSigWeather = getSigWeatherDisplayString(jwsjson.get("sigRunWalkweather"), mlang);
        sigweatherText.setText(convertTextToMultiline(dc, mSigWeather));
        
        if (mlang == 0){
            changeBitmap();
        }
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);             
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_TINY, convertTextToMultiline(dc, mSigWeather), Graphics.TEXT_JUSTIFY_CENTER);
        
        View.onUpdate( dc );
         
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }


function convertTextToMultiline(dc, text){
var extraRoom = 0.8;
var oneCharWidth = dc.getTextWidthInPixels("EtaoiNshrd",Graphics.FONT_SMALL)/10;
var charPerLine = extraRoom * dc.getWidth()/oneCharWidth;
return convertTextToMultilineHelper(text, charPerLine);
}

function convertTextToMultilineHelper(text, charPerLine) {
    if (text.length() <= charPerLine) {
        return text;
    } else {
        var i = charPerLine + 1;
        for (; i >= 0; i--) {
            if (text.substring(i, i + 1).equals("\n")) {
                break;
            }
        }
        if (i >= 0) {
            var line = text.substring(0, i);
            var textLeft = text.substring(i + 1, text.length());
            var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
            return line + "\n" + otherLines;
        } else {
            var lastChar = charPerLine + 1;
            while (!(text.substring(lastChar, lastChar + 1).equals(" ") || text.substring(lastChar, lastChar + 1).equals("\n"))&& lastChar >= charPerLine/2) {
                lastChar--;
            }
            if (lastChar >= charPerLine/2) {
                var line = text.substring(0, lastChar + 1);
                var textLeft = text.substring(lastChar + 1, text.length());
                var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
                return line + "\n" + otherLines;
            } else {
                var line = text.substring(0, charPerLine) + "-";
                var textLeft = text.substring(charPerLine, text.length());
                var otherLines = convertTextToMultilineHelper(textLeft, charPerLine);
                return line + "\n" + otherLines;
            }
        }
    }
}
    function getSigWeatherDisplayString(array, lang) {
            var displayString = "";
            for(var index = 2; index < array.size(); index++) {
                    displayString += getSigWeatherDictionaryDisplayString(array[index], lang);
                    displayString += "   ";
            }
            System.println(displayString);
            return displayString;
        }
             //Get a display string for a dictionary
    function getSigWeatherDictionaryDisplayString(dictionary, lang) {
        var displayString = Lang.format("$1$ - $2$", [dictionary["sigtitle"+lang], dictionary["sigext"+lang]]);
        if (displayString.length() > 20){
            displayString = Lang.format("$1$ \n $2$", [dictionary["sigtitle"+lang], dictionary["sigext"+lang]]);
        }
            
     
        return displayString;
    }
    function onReceive(args) {
        System.println("DetailsView onReceive:"+args);
        //System.println(args);
       /* if (args instanceof Dictionary) {
            mSigWeather = getSigWeatherDisplayString(args.get("sigRunWalkweather"), mlang);
        }
        else if (args instanceof Array){
            mMessage = getArrayDisplayString(args);
        }
        else if (args instanceof Lang.String) {
             mDate = args;
        }*/
     
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

    function changeBitmap() {
        var bitmap = findDrawableById("logoc");
        bitmap.setBitmap(Rez.Drawables.logoc_eng);
         WatchUi.requestUpdate();
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
