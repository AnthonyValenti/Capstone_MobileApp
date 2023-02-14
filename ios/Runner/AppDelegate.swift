import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAVEps7dXDhsk3ukX68J72peDrKCLJC-1M")
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "capstone.flutter.lights.on",
                                              binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
     [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      turnOn()
    })

    let controller2 : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel2 = FlutterMethodChannel(name: "capstone.flutter.lights.off",
                                              binaryMessenger: controller2.binaryMessenger)
    channel2.setMethodCallHandler({
     [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      turnOff()
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func turnOn(){
    guard let url = URL(string: "http://10.0.0.69:8081/zeroconf/switch")else{
        return
    }
    var req = URLRequest(url: url)
    req.httpMethod="POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable]=[
        "deviceid": "10014a2701",
        "data":[
            "switch": "on"
        ]
    ]
    req.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: req){ data, _, error in
        guard let data = data, error == nil else{
            return
        }
        do{
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{
            print(error)
        }
        
    }
    
    task.resume()
}

private func turnOff(){
    guard let url = URL(string: "http://10.0.0.69:8081/zeroconf/switch")else{
        return
    }
    var req = URLRequest(url: url)
    req.httpMethod="POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable]=[
        "deviceid": "10014a2701",
        "data":[
            "switch": "off"
        ]
    ]
    req.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: req){ data, _, error in
        guard let data = data, error == nil else{
            return
        }
        do{
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{
            print(error)
        }
        
    }
    
    task.resume()
}


