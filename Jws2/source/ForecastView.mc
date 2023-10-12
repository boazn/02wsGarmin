import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
class ForecastView extends WatchUi.View {
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
        System.println("ForecastView onLayout:");
        setLayout( Rez.Layouts.DetailsLayout( dc ) );
        
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
        System.println("ForecastView onShow:");            
        
        
    }

     function onLoad() {
        System.println("ForecastView onLoad:");           
    }

    // Update the view
    function onUpdate(dc as Dc) {
        System.println("ForecastView onUpdate:");
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
        var forecastDay = jwsjson["forecastDay"] as Dictionary;
        var mSigWeather = getForecastDayDisplayString(forecastDay, mlang);
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

    function getForecastDayDisplayString(forecastDay as Dictionary, lang as Number) {
           var morning = [
                :morning0,
                :morning1
            ];
           var morning_str = loadResource(Rez.Strings[morning[lang]]);
           var noon = [
                :noon0,
                :noon1
            ];
           var noon_str = loadResource(Rez.Strings[noon[lang]]);
           var night = [
                :night0,
                :night1
            ];
           var night_str = loadResource(Rez.Strings[night[lang]]);
            var displayString = forecastDay["day_name"+lang] + " " + forecastDay["date"] + "\n"
                                + forecastDay["lang"+lang] + "\n"
                                + morning_str + " " + forecastDay["TempLow"] + StringUtil.utf8ArrayToString([0xC2,0xB0]) + "\n"
                                + noon_str + " " + forecastDay["TempHigh"] + StringUtil.utf8ArrayToString([0xC2,0xB0]) + "\n"
                                + night_str + " " + forecastDay["TempNight"] + StringUtil.utf8ArrayToString([0xC2,0xB0]) + "\n";
            
            System.println(displayString);
            return displayString;
        }
    
    function onReceive(args) {
        System.println("ForecastView onReceive:"+args);
    
        WatchUi.requestUpdate();
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
 
}
