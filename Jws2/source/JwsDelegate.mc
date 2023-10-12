//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Application.Storage;
import Toybox.Lang;
(:glance)
class JwsDelegate extends WatchUi.BehaviorDelegate {
    var notify;

    // Handle menu button press
    function onMenu() {
       return doNextPage();
    }

    function doNextPage(){
        makeRequest();
        page = (page == 3) ? 1 : page + 1;
        switchView(page);
        WatchUi.requestUpdate();
        return true;
    }
    function switchView(pageNum) {

        var newView = null;
        var inputDelegate = new JwsDelegate(notify);
        var lang = Application.Properties.getValue("lang");
        if(page == 1) {
            newView = new JwsView(lang);
        }   
        else if(page == 2) {
            newView = new DetailsView(lang);
        } 
        else if(page == 3) {
            newView = new ForecastView(lang);
        } 
        else
        {
            newView = new JwsView(lang);
        }
       System.println("page=" + page);
        switchToView(newView, inputDelegate, WatchUi.SLIDE_IMMEDIATE);
    }

    function onSelect() {
        return doNextPage();
    }

    function makeRequest() as Void {
        notify.invoke("Loading...");
        try{
              
                var url = "https://www.02ws.co.il/02wsjsonshort.json";       

                var params = {                                              // set the parameters
                    "definedParams" => ""
                };

                var options = {                                             // set the options
                    :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
                    :headers => {                                           // set headers
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                    // set response type
                    :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };

                var responseCallback = method(:onReceive);                  // set responseCallback to
                // onReceive() method
                // Make the Communications.makeWebRequest() call
                Communications.makeWebRequest(url, params, options, responseCallback);
      
            
        }
        catch(exception){
            System.println(exception);
           
        }
       
    }

    // Set up the callback to the view
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
        notify.invoke("init: make request");
        makeRequest();
    }

    function dump_device_information() {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings has :monkeyVersion) {
            System.println(Lang.format("MonkeyC Version: $1$.$2$.$3$", deviceSettings.monkeyVersion));
        }
        else {
            System.println("MonkeyC Version: < 1.2.0");
        }

        if (deviceSettings has :partNumber) {
            System.println(Lang.format("Device Part Num: $1$", [ deviceSettings.partNumber ]));
        }
    }

    // Receive the data from the web request
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("JwsDelegate onReceive got data:");
            var myStats = System.getSystemStats();
            System.println("totalMemory:" + myStats.totalMemory);
            System.println("freeMemory:" + myStats.freeMemory );
            if ((Toybox.Application has :Storage)&&(myStats.freeMemory > 14000)){
            
                Storage.setValue("02wsjson", data);
                System.println("saved to storage");
            }
            else if (myStats.freeMemory > 8000) {
                Application.Properties.setValue("02wsjson", data);
            }
            
            notify.invoke(data);
          } else {
            //notify.invoke("Failed to load\nError: " + responseCode.toString());
            dump_device_information();
            System.println("ResoponseCode:" + responseCode.toString());
            var myStats = System.getSystemStats();
            if ((Toybox.Application has :Storage)&&(myStats.freeMemory > 12000)){
                notify.invoke(Storage.getValue("02wsjson"));
            }
            else{
                notify.invoke(Application.Properties.getValue("02wsjson"));
            }
            
        }
    }
}